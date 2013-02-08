module Sideband
  class Worker

    def call
      raise NotImplementedError.new('Define your Work in a Worker subclass.')
    end
    
    def enqueue
      Sideband.queue << self
      true
    end
    alias_method :queue, :enqueue
  end
end
