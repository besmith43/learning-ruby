#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
module Sequel
  # Represents an error raised in Sequel code.
  class Error < StandardError
    
    # Error raised when an invalid statement is executed.
    class InvalidStatement < Error; end

    # Rollback is a special error used to rollback a transactions.
    # A transaction block will catch this error and wont pass further up the stack.
    class Rollback < Error ; end
    
    # Represents an invalid value stored in the database.
    class InvalidValue < Error ; end
                                       
    # Represents an Invalid transform.
    class InvalidTransform < Error ; end
    
    # Raised on an invalid operation.
    class InvalidOperation < Error; end
                                       
    # Represents an Invalid filter.    
    class InvalidFilter < Error ; end
    
    class InvalidExpression < Error; end
                                       
    # Represents an attempt to performing filter operations when no filter has been specified yet.
    class NoExistingFilter < Error ; end
                                       
    # Represents an invalid join type.
    class InvalidJoinType < Error ; end
                                       
    class WorkerStop < RuntimeError ; end
    
    # Raised when Sequel is unable to load a specified adapter.
    class AdapterNotFound < Error ; end
  end  
end

# Object extensions
class Object
  # Cancels the current transaction without an error:
  #
  #   DB.tranaction do
  #     ...
  #     rollback! if failed_to_contact_client
  #     ...
  #   end
  def rollback!
    raise Sequel::Error::Rollback
  end
end
