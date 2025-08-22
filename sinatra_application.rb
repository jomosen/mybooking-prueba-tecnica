require_relative 'lib/autoregister'

module Sinatra
  class Application < Sinatra::Base

    configure do
      set :root, File.expand_path('..', __FILE__)
      set :views, File.join(root, 'app/views')
      set :public_folder, File.join(root, 'app/assets')
    end

    # Include the routes defined in the controller
    register Sinatra::AutoRegister

  end
end
