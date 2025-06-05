class HomepageController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    # This action will render the homepage view
  end
end