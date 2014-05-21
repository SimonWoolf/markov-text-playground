# Precompile sass -> css
require 'sass/plugin/rack'
# Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

require './server'
run Sinatra::Application
