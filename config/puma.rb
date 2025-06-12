# config/puma.rb

# Only use multiple workers in production
if ENV['RAILS_ENV'] == 'production'
  workers Integer(ENV['WEB_CONCURRENCY'] || 2)
end

threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

port        ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
