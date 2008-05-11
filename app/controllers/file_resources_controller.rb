class FileResourcesController < ApplicationController
  # GET /file_resources
  def index
    @file_resources = FileResource.find_all
  end

  # GET /file_resources/new
  # GET /file_resources/new.xml
  def new
    @file_resource = FileResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @file_resource }
    end
  end

  # POST /file_resources
  def create
    @file_resource = FileResource.new(params[:file].original_filename)
    @file_resource.write(params[:file].read)
    flash[:notice] = 'FileResource was successfully created.'
    redirect_to file_resource_path
  end

  # DELETE /file_resources/1
  # DELETE /file_resources/1.xml
  def destroy
    @file_resource = FileResource.find(params[:id])
    @file_resource.destroy

    respond_to do |format|
      format.html { redirect_to(file_resources_url) }
      format.xml  { head :ok }
    end
  end
end
