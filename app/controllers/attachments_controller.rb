class AttachmentsController < ApplicationController
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
      Attachment.create(params[:file].original_filename, params[:file].read)
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'Attachment successfully created.'
    end
    redirect_to attachments_path
  end

  # DELETE /file_resources/1
  def destroy
    begin
      Attachment.delete(params[:id])
    rescue RuntimeError => err
      flash[:error] = err.message
    else
      flash[:notice] = 'Attachment successfully delete.'
    end
    redirect_to attachments_path
  end
end
