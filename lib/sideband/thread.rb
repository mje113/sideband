module Sideband
  class Thread

    attr_reader :thread

    def initialize(manager)
      @manager = manager
      @thread = ::Thread.new do
        while work = @manager.queue.pop
          exit if work.nil?
          
          begin
            work.call
          rescue Exception
            # Sideband will ignore all Exceptions, 
            # better to handle in your workers.
          end
        end
      end
    end

    def join
      thread.join
    end

    def kill
      thread.kill
    end
  end
end
