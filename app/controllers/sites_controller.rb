class SitesController < ApplicationController
  
  def index
    render file: 'public/index.html', layout: false

  end

  def show
    site_id = params[:id]
    root = Site.find(site_id).root
    page_count = Page.where(site_id: site_id).count
    pages_remaining_count = Page.where(status: nil, site_id: site_id).count
    errors = Page.where('status > 399').to_a.map do |page|
      {
        url: page.url,
        path: page.path
      }
    end
    
    render json: {
      page_count: page_count,      
      avg_response_time: 0,
      pages_remaining_count: pages_remaining_count,
      errors: errors,
      root: root
    }
  end

  def start            
    Page.where(site_id: params[:site_id]).delete_all
    Page.where(site_id: nil).delete_all
    $redis.del "queue#{params[:site_id]}"
    root_page = Page.where(site_id: params[:site_id], path: '/').first_or_create
    Resque.enqueue Crawler, root_page.id    
  end


end
