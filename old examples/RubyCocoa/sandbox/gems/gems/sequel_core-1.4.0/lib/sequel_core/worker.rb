#---
# Excerpted from "RubyCocoa",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmrc for more book information.
#---
require "thread"

module Sequel

  class Worker < Thread
      
    attr_reader :queue
    attr_reader :errors
  
    def initialize(db = nil)
      @queue = Queue.new
      @errors = []
      t = self
      t.abort_on_exception = true
      @transaction = !db.nil?
      db ? super {db.transaction {t.work}} : super {t.work}
    end
    
    def work
      loop {next_job}
    rescue Sequel::Error::WorkerStop # signals the worker thread to stop
    ensure
      rollback! if @transaction && !@errors.empty?
    end
    
    def busy?
      @cur || !@queue.empty?
    end
  
    def async(proc = nil, &block)
      @queue << (proc || block)
      self
    end
    alias_method :add, :async
    alias_method :<<, :async
  
    def join
      while busy?
        sleep 0.1
      end
      self.raise Error::WorkerStop
      super
    end

    private
    def next_job
      @cur = @queue.pop
      @cur.call
    rescue Error::WorkerStop => e
      raise e
    rescue Exception => e
      @errors << e
    ensure
      @cur = nil
    end
  end

end
