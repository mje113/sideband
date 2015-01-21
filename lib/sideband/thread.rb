module Sideband
  class Thread

    attr_reader :thread

    def initialize(manager)
      @thread = ::Thread.new do
        queue = manager.queue
        while true
          work = queue.pop
          if work.nil?
            exit
          else
            begin
              work.call
            rescue Exception
              # Sideband will ignore all Exceptions,
              # better to handle in your workers.
            end
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
