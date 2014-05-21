require 'sinatra'
require 'haml'
require 'better_errors'

# Settings
set :partial_template_engine, :haml
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('.', __FILE__)
end


# Controllers
get '/' do
  "#{ENV['RACK_ENV']}"
end

# Helpers
helpers do
end
