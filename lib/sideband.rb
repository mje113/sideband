require 'thread'
require 'sideband/version'
require 'sideband/manager'
require 'sideband/queue'
require 'sideband/thread'
require 'sideband/worker'

module Sideband

  def self.initialize!
    new_manager = Manager.new

    if block_given?
      begin
        ::Thread.current['sideband.manager'] = new_manager
        yield
      ensure
        join
      end
    else
      ::Thread.current['sideband.manager'] = new_manager
    end
  end

  def self.join
    manager.join
    kill
  end

  def self.kill
    manager.kill
    ::Thread.current['sideband.manager'] = nil
  end

  def self.queue(job = nil)
    if job
      manager.queue << job
    else
      manager.queue
    end
  end

  def self.enqueue(job = nil)
    queue(job)
  end

  def self.manager
    manager = ::Thread.current['sideband.manager']
    manager = initialize! if manager.nil?
    manager
  end

end
