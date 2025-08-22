require_relative 'config/application'

# Setup rack session
use Rack::Session::Cookie, :secret => ENV['COOKIE_SECRET'],
                           :key => 'rack.session',
                           :path => '/',
                           :expire_after => 86400

# Setup sinatra application
require_relative 'sinatra_application'
app = Rack::Builder.new do
  map "/" do
    run Sinatra::Application
  end
end

run app

# Prepare debug
if File.exist?('debug.txt')
  ENV['RUBY_DEBUG_NONSTOP'] = '1'
  ENV['RUBY_DEBUG_OPEN'] = "tcp://127.0.0.1:1234"
  require 'debug'
end
