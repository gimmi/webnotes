class PagesController < ApplicationController
  before_filter :authorize, :except => [:index, :title, :show]
  
  # GET /pages
  def index
    conditions = ['public = ?', true] if guest?
    @pages = Page.find(:all, :order => 'url_title', :conditions => conditions)
  end
  
  # GET /pages/title/url-title
  def title
    @page = Page.find_by_url_title(params[:id])
    if @page
      if @page.private? && guest?
        authorize
      else
        @page_title = @page.title
        @page_body = @page.html_body do |url_title|
          url_for :action => 'title', :id => url_title, :only_path => true
        end
      end
    else
      flash[:error] = "Page with title '#{params[:id]}' not found"
      redirect_to pages_path
    end
  end
  
  # GET /pages/1
  def show
    page = Page.find(params[:id])
    flash.keep
    redirect_to :action => 'title', :id => page.url_title
  end

  # GET /pages/new
  def new
    @page = Page.new
    render :action => 'edit'
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to(@page)
    else
      render :action => 'edit'
    end
  end

  # PUT /pages/1
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes_with_versioning(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect_to(@page)
    else
      render :action => "edit"
    end
  end

  # DELETE /pages/1
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to(pages_url)
  end
  
#  private
#  
#  def readable_page_path(url_title)
#    url_for :action => 'title', :id => url_title, :only_path => true
#  end
end
