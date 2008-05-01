class SessionsController < ApplicationController
  # GET /sessions/new
  def new
    flash.keep :original_uri
  end

  # POST /sessions
  def create
    if login(params[:password])
      flash[:notice] = 'Succesfully logged in.'
      redirect_to flash[:original_uri]
    else
      flash[:error] = 'Wrong password.'
      flash.keep :original_uri
      redirect_to new_session_path
    end
  end

  # DELETE /sessions/1
  def destroy
    logout
    flash[:notice] = 'Succesfully logged out.'
    redirect_to ''
  end
end
