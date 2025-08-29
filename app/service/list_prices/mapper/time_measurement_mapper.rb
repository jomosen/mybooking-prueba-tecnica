module Service
  module ListPrices
    module Mapper
      class TimeMeasurementMapper
        
        VALUES = %i[months days hours minutes].freeze

        def self.coerce(input)
          return nil if input.nil?
          sym = input.to_s.strip.downcase.to_sym
          VALUES.include?(sym) ? sym : nil
        end

        def self.to_db(input)
          sym = coerce(input)
          sym ? VALUES.index(sym) : nil
        end

        def self.from_db(int)
          VALUES[int]
        end

        def self.to_api(int)
          from_db(int).to_s
        end

      end
    end 
  end
end
