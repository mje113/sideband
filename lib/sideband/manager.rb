module Sideband
  class Manager

    def initialize
      @pid = ::Process.pid
      thread!
      queue!
    end

    def queue
      handle_fork
      handle_dead_thread
      @queue
    end

    def thread
      @thread
    end

    def join
      @queue.kill
      @thread.join
    end

    def kill
      @thread.kill
      @thread = @queue = nil
    end

    private

    def queue!
      @queue = Sideband::Queue.new
    end

    def thread!
      @thread.kill if @thread
      @thread = Sideband::Thread.new(self)
    end

    def handle_fork
      if ::Process.pid != @pid
        @pid = ::Process.pid
        thread!
        queue!
      end
    end

    def handle_dead_thread
      unless (@thread && @thread.thread.alive?)
        thread!
      end
    end
  end
end
