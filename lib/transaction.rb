module Infraestructure
  #
  # Infraestructure class to execute a DB transaction
  #
  class Transaction

    #
    # Encapsulate the code within a transaction to avoid the use of the ORM in the code
    #
    def self.within_transaction(isolation_level = :default, &block)

      if isolation_level == :read_committed
        DataMapper.repository(:default).adapter.select('SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED')
      end

      DataMapper::Transaction.new(DataMapper.repository(:default)).commit do |transaction|
        yield transaction
      end

    end

  end
end
