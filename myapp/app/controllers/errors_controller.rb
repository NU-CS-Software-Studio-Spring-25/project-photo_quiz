# Manage the errors in the application
class ErrorsController < ApplicationController
  def show
    @status_code = params[:code] || 500
    @message =
      case @status_code.to_i
      when 404
        "Page Not Found"
      when 500
        "Server Error"
      when 400
        "Bad Request"
      else
        "An error has occurred"
      end
    render :show, status: @status_code
  end
end
