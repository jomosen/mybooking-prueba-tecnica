module Controller
  module Serializer
    class BaseSerializer

      #
      # Retrieve all the attributes of the resource
      #
      def attributes(resource)
        resource.attributes
      end

      #
      # Execute the serializer
      #
      def serialize(resource, options = {})

        base = attributes(resource).dup

        # Only selected keys
        if options[:only]
          base.select! { |k, _| options[:only].include?(k) }
        end

        # Add methods
        if options[:methods]
          options[:methods].each do |m|
            base[m] = resource.send(m) if resource.respond_to?(m)
          end
        end

        # Add relationships
        if options[:relationships]
          options[:relationships].each do |rel, rel_opts|
            rel_data = resource.send(rel)

            base[rel] =
              if rel_data.nil?
                nil
              elsif rel_data.respond_to?(:map) # Collection has n or one_to_many
                rel_data.map { |r| serialize(r, rel_opts || {}) }
              else # Belongs to or many_to_one, one_to_one
                serialize(rel_data, rel_opts || {})
              end
          end
        end

        base
      end

    end
  end
end
