class AttachmentsController < ApplicationController
  
  before_filter :authorize

  # GET /attachments
  def index
    @attachments = Attachment.find(:all)
  end

  # GET /attachments/new
  def new
  end

  # POST /attachments
  def create
    begin
      attachment = Attachment.new(params[:file].original_filename)
      attachment.write(params[:file].read)
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'Attachment successfully created.'
    end
    redirect_to attachments_path
  end

  # DELETE /file_resources/1
  def destroy
    name = params[:id]
    attachment = Attachment.find(name)
    if attachment
      attachment.delete
      flash[:notice] = 'Attachment successfully delete.'
    else
      flash[:error] = "Attachment '#{name}' not found."
    end
    redirect_to attachments_path
  end
end
