require 'helper'

class TestThread < MiniTest::Unit::TestCase

  def setup
    @manager = OpenStruct.new(queue: OpenStruct.new)
  end

  def test_initialized
    thread = Sideband::Thread.new(@manager)
    assert_kind_of ::Thread, thread.thread
  end

  def test_killed
    thread = Sideband::Thread.new(@manager)
    thread.kill
    sleep 0.1
    refute thread.thread.alive?
  end

  def test_joined
    work = 'work'
    @manager.queue = Queue.new
    @manager.queue << -> { work = 'finished' }
    @manager.queue << nil
    thread = Sideband::Thread.new(@manager)

    thread.join
    refute thread.thread.alive?
    assert_equal 'finished', work
  end
end
