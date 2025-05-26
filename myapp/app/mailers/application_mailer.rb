# Handles the base configuration for all mailers in the application.
# Purpose: This file defines the base class for all mailers in the application.
# It sets the default "from" address and specifies the layout for emails.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
