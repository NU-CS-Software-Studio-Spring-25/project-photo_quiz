// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"
import "@popperjs/core" // Required for Bootstrap tooltips and popovers
import "@rails/ujs";
import Rails from "@rails/ujs"
Rails.start();

import "@hotwired/turbo-rails"   // if you’re using Turbo
import "./controllers"           // if you have Stimulus
import "./quiz"
