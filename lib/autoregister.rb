module Sinatra
  module AutoRegister
    def self.registered(app)

      # Registrar todos los módulos automáticamente
      Dir[File.join(File.dirname(__FILE__), '..', 'app', 'controller', '**', '*.rb')].each do |file|

        # Obtiene la ruta relativa desde la carpeta 'app/controller'
        relative_path = file.sub(File.join(File.dirname(__FILE__), '..', 'app', 'controller'), '')  # Elimina la ruta base

        # Asegura que la ruta no contenga '..' y que solo procesemos rutas válidas
        next if relative_path.include?('..')

        # Excluir la carpeta serializer
        next if relative_path.include?('/serializer/')

        # Elimina la extensión .rb y convierte las carpetas en nombres de módulos
        module_name = relative_path.sub('.rb', '').gsub('/', '::')

        # Convierte a CamelCase: capitaliza cada parte que estaba en snake_case
        module_name = module_name.split('::').map { |part| part.split('_').map(&:capitalize).join('') }.join('::')

        # Asegura que el módulo esté bajo controller:: y elimina cualquier prefijo '::' innecesario
        module_name = "Controller::#{module_name.sub(/^::/, '')}"

        p "module_name: #{module_name} loaded"

        # Genera el nombre completo del módulo y registra el módulo en la aplicación
        begin
          module_constant = Object.const_get(module_name)
          app.register(module_constant)
        rescue NameError => e
          p "Error loading module #{e.message} - file: #{file}"
        end
      end
    end
  end
end
