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
  if markov.nil?
    @status = "Select inputs and press 'Analyze'"
    @ready = false
  else
    textstring = MarkovCache::texts.join(", ")
    @status = "✔ Dictionary built from: #{textstring}"
    @ready = true
  end
  haml :index
end

post '/' do
  texts = params["texts"].split(",")
  markov = Markov.new(texts.map {|t| "./inputs/#{t}.txt"})
  MarkovCache::markov = markov
  MarkovCache::texts = texts
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
  @@texts = nil

  def self.markov=(markov)
    @@markov = markov
  end

  def self.texts=(texts)
    @@texts = texts
  end

  def self.markov
    @@markov
  end

  def self.texts
    @@texts
  end
end
