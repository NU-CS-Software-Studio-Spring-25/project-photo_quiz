class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:full_name])
  end
end

# Adding a custom ErrorsController to handle error pages
class ErrorsController < ApplicationController
  def not_found
    render status: 404
  end

  def internal_server_error
    render status: 500
  end
end
