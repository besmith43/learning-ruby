#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'active_record/vendor/simple.rb'
require 'thread'

module ActiveRecord
  module Transactions # :nodoc:
    TRANSACTION_MUTEX = Mutex.new

    def self.append_features(base)
      super
      base.extend(ClassMethods)

      base.class_eval do
        alias_method :destroy_without_transactions, :destroy
        alias_method :destroy, :destroy_with_transactions

        alias_method :save_without_transactions, :save
        alias_method :save, :save_with_transactions
      end
    end

    # Transactions are protective blocks where SQL statements are only permanent if they can all succed as one atomic action. 
    # The classic example is a transfer between two accounts where you can only have a deposit if the withdrawal succedded and
    # vice versa. Transaction enforce the integrity of the database and guards the data against program errors or database break-downs.
    # So basically you should use transaction blocks whenever you have a number of statements that must be executed together or
    # not at all. Example:
    #
    #   Account.transaction do
    #     david.withdrawal(100)
    #     mary.deposit(100)
    #   end
    #
    # This example will only take money from David and give to Mary if neither +withdrawal+ nor +deposit+ raises an exception.
    # Exceptions will force a ROLLBACK that returns the database to the state before the transaction was begun. Be aware, though,
    # that the objects by default will _not_ have their instance data returned to their pre-transactional state.
    #
    # == Save and destroy are automatically wrapped in a transaction
    #
    # Both Base#save and Base#destroy come wrapped in a transaction that ensures that whatever you do in validations or callbacks
    # will happen under the protected cover of a transaction. So you can use validations to check for values that the transaction
    # depend on or you can raise exceptions in the callbacks to rollback.
    #
    # == Object-level transactions
    #
    # You can enable object-level transactions for Active Record objects, though. You do this by naming the each of the Active Records
    # that you want to enable object-level transactions for, like this:
    #
    #   Account.transaction(david, mary) do
    #     david.withdrawal(100)
    #     mary.deposit(100)
    #   end
    #
    # If the transaction fails, David and Mary will be returned to their pre-transactional state. No money will have changed hands in
    # neither object nor database.
    #
    # == Exception handling
    #
    # Also have in mind that exceptions thrown within a transaction block will be propagated (after triggering the ROLLBACK), so you
    # should be ready to catch those in your application code.
    #
    # Tribute: Object-level transactions are implemented by Transaction::Simple by Austin Ziegler.
    module ClassMethods      
      def transaction(*objects, &block)
        TRANSACTION_MUTEX.lock

        begin
          objects.each { |o| o.extend(Transaction::Simple) }
          objects.each { |o| o.start_transaction }
          connection.begin_db_transaction

          block.call
  
          connection.commit_db_transaction
          objects.each { |o| o.commit_transaction }
        rescue Exception => exception
          connection.rollback_db_transaction
          objects.each { |o| o.abort_transaction }
          raise exception
        ensure
          TRANSACTION_MUTEX.unlock
        end
      end
    end

    def destroy_with_transactions #:nodoc:
      if TRANSACTION_MUTEX.locked?
        destroy_without_transactions
      else
        ActiveRecord::Base.transaction { destroy_without_transactions }
      end
    end
    
    def save_with_transactions(perform_validation = true) #:nodoc:
      result = nil
      if TRANSACTION_MUTEX.locked?
        result = save_without_transactions(perform_validation)
      else
        ActiveRecord::Base.transaction { result = save_without_transactions(perform_validation) }
      end
      return result
    end
  end
end