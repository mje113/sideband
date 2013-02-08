module Sideband
  class Queue

    def initialize
      @queue = ::Queue.new
    end

    def kill
      @queue << nil
    end

    def push(work)
      return false if work.nil?
      @queue.push(work)
      true
    end
    alias_method :<<, :push

    def pop
      @queue.pop
    end

  end
end
