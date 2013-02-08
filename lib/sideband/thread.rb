module Sideband
  class Thread
    def initialize
      @thread = ::Thread.new do
        while work = Sideband.queue.pop
          begin
            work.call
          rescue Exception
            # Sideband will ignore all Exceptions, 
            # better to handle in your workers.
          end
        end
      end
    end

    def kill
      @thread.kill
    end
  end
end
