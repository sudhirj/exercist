class Page < ActiveRecord::Base
  belongs_to :site

  def url
    URI.join(site.root, path).to_s
  end

  def already_crawled?
    !status.nil?
  end
end
