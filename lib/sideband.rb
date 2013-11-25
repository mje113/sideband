require 'thread'
require 'sideband/version'
require 'sideband/manager'
require 'sideband/queue'
require 'sideband/thread'
require 'sideband/worker'

module Sideband

  @manager = nil

  def self.initialize!
    @manager = Manager.new

    if block_given?
      begin
        yield
      ensure
        join
      end
    else
      @manager
    end
  end

  def self.join
    manager.join
    kill
  end

  def self.kill
    manager.kill
    @manager = nil
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
    m = @manager
    m = initialize! if m.nil?
    m
  end

end
