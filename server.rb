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
  markov = MarkovCache::markov
  @test = markov.popular_successors_to("the") unless markov.nil?
  puts @test.inspect
  haml :index
end

post '/' do
  params["texts"].split(",")
  markov = Markov.new(["./inputs/foundation.txt"])
  MarkovCache::markov = markov
  redirect '/'
end

# Helpers
helpers do
end

class MarkovCache
  # Persistant cache of the current markov object.
  # NB we assume this app will only ever have
  # one user - need to move to session-based cache if that
  # ever changes

  @@markov = nil

  def self.markov=(markov)
    @@markov = markov
  end

  def self.markov
    @@markov
  end
end
