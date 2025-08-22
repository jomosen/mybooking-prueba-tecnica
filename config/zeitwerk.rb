require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path('../app', __dir__))

# Ignorar archivos que no son clases Ruby
loader.ignore(File.expand_path('../app/assets', __dir__))
loader.ignore(File.expand_path('../app/views', __dir__))

# Configurar el modo de carga
loader.enable_reloading if ENV['RACK_ENV'] == 'development'

loader.setup

# Make sure all models are loaded explicitly
# It must be done before DataMapper.finalize in order to work with datamapper
loader.eager_load_dir("./app/model")
