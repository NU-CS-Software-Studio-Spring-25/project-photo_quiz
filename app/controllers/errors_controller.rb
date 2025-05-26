class ErrorsController < ApplicationController
  def show
    status_code = params[:code] || 500
    render_error(status_code)
  end
end