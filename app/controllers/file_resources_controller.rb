class FileResourcesController < ApplicationController
  # GET /file_resources
  # GET /file_resources.xml
  def index
    @file_resources = FileResource.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @file_resources }
    end
  end

  # GET /file_resources/1
  # GET /file_resources/1.xml
  def show
    @file_resource = FileResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @file_resource }
    end
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

  # GET /file_resources/1/edit
  def edit
    @file_resource = FileResource.find(params[:id])
  end

  # POST /file_resources
  # POST /file_resources.xml
  def create
    @file_resource = FileResource.new(params[:file_resource])

    respond_to do |format|
      if @file_resource.save
        flash[:notice] = 'FileResource was successfully created.'
        format.html { redirect_to(@file_resource) }
        format.xml  { render :xml => @file_resource, :status => :created, :location => @file_resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @file_resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /file_resources/1
  # PUT /file_resources/1.xml
  def update
    @file_resource = FileResource.find(params[:id])

    respond_to do |format|
      if @file_resource.update_attributes(params[:file_resource])
        flash[:notice] = 'FileResource was successfully updated.'
        format.html { redirect_to(@file_resource) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @file_resource.errors, :status => :unprocessable_entity }
      end
    end
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
