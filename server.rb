require 'sinatra'
require 'sinatra/partial'
require 'sinatra-websocket'
require 'haml'
require 'json'
require 'better_errors' if development?
require 'aws/s3'

# Settings
set :partial_template_engine, :haml
set :server, 'thin'
set :sockets, []
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('.', __FILE__)
end

# Models & lib code
require_relative 'lib/markov'
require_relative 'models/markov_cache'


# Controllers
get '/' do
  if request.websocket?
    process_ws(request)
  else
    set_status
    haml :index
  end
end

post '/' do
  texts = params["texts"].split(",")
  create_markov(texts) unless texts.empty?
  redirect '/'
end

get '/randomword' do
  markov = MarkovCache::markov
  return if markov.nil?
  return markov.random_word
end

# helpers
def create_markov(texts)
  markov = Markov.new(texts.map {|t| "./inputs/#{t}.txt"})
  MarkovCache::markov = markov
  MarkovCache::texts = texts
end

def set_status
  markov = MarkovCache::markov
  if markov.nil?
    @status = "Select inputs and press 'Analyze'"
  else
    textstring = MarkovCache::texts.join(", ")
    @status = "✔ Dictionary built from: #{textstring}"
  end
end

def process_ws(request)
  request.websocket do |ws|
    ws.onopen do
      warn("websocket open")
      settings.sockets << ws
    end
    ws.onmessage do |word|
      markov = MarkovCache::markov
      unless markov.nil?
        successors = markov.popular_successors_to(word.strip)
        EM.next_tick { settings.sockets.each{|s| s.send(successors.to_json) } }
      end
    end
    ws.onclose do
      warn("websocket closed")
      settings.sockets.delete(ws)
    end
  end
end
