class Stack
  def initialize
    stack = caller
    stack.shift
    @backtrace = stack.map do |call|
      Call.new(call)
    end
  end

  def report
    @backtrace.map do |call|
      call.to_s
    end
  end

  def find(&block)
    @backtrace.find(&block)
  end
end