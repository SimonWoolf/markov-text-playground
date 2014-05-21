require 'sinatra'
require 'sinatra/partial'
require 'haml'
require 'better_errors'
require_relative 'lib/markov'

# Settings
set :partial_template_engine, :haml
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('.', __FILE__)
end


# Controllers
get '/' do
  markov = Markov.new(["./inputs/foundation.txt"])
  @test = markov.popular_successors_to("the")
  haml :index
end

# Helpers
helpers do
end
