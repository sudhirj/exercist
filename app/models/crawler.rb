
class Crawler  
  include HTTParty

  @queue = :crawl_queue
  def self.perform(page_id)
    page = Page.find page_id
    return if page.already_crawled?
    
    site = page.site
    url = page.url

    Rails.logger.info "Crawling URL: #{url}"    
    begin
      response = self.get url, no_follow: true
    rescue HTTParty::RedirectionTooDeep => problem
      response = problem.response
    end
    page.status = response.code
    page.save
    
    return if response.code != 200 
        
    doc = Nokogiri::HTML(response.body)
    links = doc.css 'a'
    hrefs = links.map{|link| link.attribute('href').to_s}.reject{|href| href.blank?}.uniq
    hrefs = self.reject_uncrawlables hrefs, site.root
    hrefs = self.normalize hrefs, site.root
    uris = hrefs.map{|href| URI.parse href }
    uris = self.reject_externals uris, site.root
    Site.transaction do
      pages = uris.map do |uri|
        site.pages.where(path: uri.request_uri).first_or_create
      end    
      pages.each do |page|
        self.queue page
      end
    end
  end

  def self.queue(page)
    return if $redis.sismember "queue#{page.site.id}", page.id.to_s
    Resque.enqueue(Crawler, page.id) if not page.already_crawled?
    $redis.sadd "queue#{page.site.id}", page.id.to_s
  end

  def self.reject_uncrawlables(hrefs, root)
    hrefs.reject{|href| href.start_with?('#')}    
  end

  def self.normalize(hrefs, root)
    hrefs.map do |href|
      href.start_with?('http') ? href : URI.join(root, href).to_s      
    end
  end

  def self.reject_externals(uris, root)
    root_host = URI.parse(root).host
    uris.reject{|uri| uri.host != root_host}
  end
end

