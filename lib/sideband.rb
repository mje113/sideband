require 'thread'
require 'sideband/version'
require 'sideband/thread'
require 'sideband/worker'

module Sideband

  class SubThreadError < Exception; end

  def self.initialize!
    if ::Thread.current != ::Thread.main
      raise SubThreadError.new('Sideband can only be initialized in the main thread.')
    end

    @pid = ::Process.pid

    queue!
    puts 'Sideband queue initialized!'
    thread!
    puts 'Sideband thread initialized!'
  end

  def self.queue
    handle_fork
    @queue ||= ::Queue.new
  end

  def self.thread
    @thread ||= Sideband::Thread.new
  end

  def self.queue!
    @queue = nil
    queue
  end

  def self.thread!
    if @thread
      @thread.kill
      @thread = nil
    end
    thread
  end

  def self.handle_fork
    if ::Process.pid != @pid
      @pid = ::Process.pid
      initialize!
    end
  end
end
