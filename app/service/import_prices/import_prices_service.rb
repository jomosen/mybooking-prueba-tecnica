module Service
  module ImportPrices
    class ImportPricesService

      def initialize(crlrt_repository:, pd_repository:, units_policy:, price_repository:, logger:)
        @crlrt_repository = crlrt_repository
        @pd_repository = pd_repository
        @units_policy = units_policy
        @price_repository = price_repository
        @logger = logger
      end

      def process_batch(batch)

        prices = batch.prices

        result = { success: false, item_index: -1, processed: 0, skipped: 0, warnings: [], errors: [] }

        Infraestructure::Transaction.within_transaction(:read_committed) do |tx|

          begin

            prices.each do |price|

              result[:item_index] += 1

              price_attributes = price.attributes.dup

              category_rental_location_rate_type = retrieve_category_rental_location_rate_type(
                category_id: price_attributes[:category_id],
                rental_location_id: price_attributes[:rental_location_id],
                rate_type_id: price_attributes[:rate_type_id]
              )
              unless category_rental_location_rate_type
                raise Error::ImportAbortedError.new(item_index: result[:item_index], code: :category_rental_location_rate_type_not_found, detail: "CategoryRentalLocationRateType not found")
              end

              price_definition = retrieve_price_definition(category_rental_location_rate_type.price_definition_id)
              unless price_definition
                raise Error::ImportAbortedError.new(item_index: result[:item_index], code: :price_definition_not_found, detail: "PriceDefinition not found")
              end

              # Salta el precio si units no es un valor válido para la definición del precio
              unless @units_policy.allowed?(
                price_definition: price_definition, 
                time_measurement: price_attributes[:time_measurement], 
                units: price_attributes[:units]
              )
                result[:skipped] += 1
                result[:processed] += 1
                result[:warnings] << { item_index: result[:item_index], code: :units_not_allowed, detail: "Units #{price_attributes[:units]} not present in the price definition." }
                next
              end

              # Se añade el identificador de la definición de precio antes de persistir
              command = price_attributes.merge(price_definition_id: price_definition.id)

              @price_repository.upsert(command)

              result[:processed] += 1
            end

            result[:success] = true

          rescue Error::ImportAbortedError => e
            result[:errors] << { item_index: e.item_index, code: e.code, detail: e.detail }
            tx.rollback

          rescue => e
            result[:errors] << { item_index: nil, code: :unknown_error, detail: e.message }
            tx.rollback
          end
        end

        result
      end

      private

      def retrieve_category_rental_location_rate_type(category_id:, rental_location_id:, rate_type_id:)
        @crlrt_repository.first({
          category_id: category_id,
          rental_location_id: rental_location_id,
          rate_type_id: rate_type_id
        })
      end

      def retrieve_price_definition(price_definition_id)
        @pd_repository.first({
          id: price_definition_id
        })
      end

    end
  end
end