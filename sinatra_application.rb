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

    #
    # Home page sample
    #
    get '/' do

      use_case = PageUseCase::Home::PageHomeUseCase.new(logger)
      result = use_case.perform(params)

      @title = "Home page"

      if result.success?
        @message = result.data
        erb :index
      else
        @message = result.message
        erb :error_page
      end

    end

  end
end
