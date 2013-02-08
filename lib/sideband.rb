require 'thread'
require 'sideband/version'
require 'sideband/manager'
require 'sideband/queue'
require 'sideband/thread'
require 'sideband/worker'

module Sideband

  class NotInitializedError < Exception; end

  def self.initialize!
    new_manager = Manager.new
    puts 'Sideband initialized!'

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

  def self.queue
    manager.queue
  end

  def self.manager
    manager = ::Thread.current['sideband.manager']
    raise NotInitializedError.new('Sideband must be initialized! before using.') if manager.nil?
    manager
  end

end
