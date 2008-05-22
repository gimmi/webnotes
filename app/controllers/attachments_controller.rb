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
      Attachment.new(params[:file].original_filename).write(params[:file].read)
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'Attachment successfully created.'
    end
    redirect_to attachments_path
  end

  # DELETE /file_resources/1
  def destroy
    Attachment.new(params[:id]).delete
    flash[:notice] = 'Attachment successfully delete.'
    redirect_to attachments_path
  end
end
