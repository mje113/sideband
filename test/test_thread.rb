require 'helper'

class TestThread < MiniTest::Unit::TestCase

  def test_initialized
    thread_count = Thread.list.size
    Sideband::Thread.new
    assert_equal thread_count + 1, Thread.list.size
  end

  def test_killed
    thread_count = Thread.list.size
    thread = Sideband::Thread.new
    thread.kill
    sleep 0.1
    assert_equal thread_count, Thread.list.size
  end
end