class FileResourcesController < ApplicationController
  # GET /file_resources
  def index
    @file_resources = FileResource.find(:all)
  end

  # GET /file_resources/new
  def new
  end

  # POST /file_resources
  def create
    begin
      FileResource.create(params[:file].original_filename, params[:file].read)
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'FileResource successfully created.'
    end
    redirect_to file_resources_path
  end

  # DELETE /file_resources/1
  def destroy
    begin
      FileResource.delete(params[:id])
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'FileResource successfully delete.'
    end
    redirect_to file_resources_path
  end
end
