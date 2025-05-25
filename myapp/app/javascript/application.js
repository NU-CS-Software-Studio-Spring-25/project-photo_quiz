// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "quiz"
import "controllers"
import * as Rails from '@rails/ujs';
console.log(Rails)
Rails.start()