module Infraestructure
  #
  # Infraestructure class to execute queries
  #
  class Query

    #
    # Encapsulate the code within a transaction to avoid the use of the ORM in the code
    #
    def self.run(sql, *arguments)

      DataMapper.repository(:default).adapter.select(sql, *arguments)

    end

  end
end
