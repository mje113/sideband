require 'helper'

class TestSideband < MiniTest::Unit::TestCase

  def test_can_only_be_initialized_in_main_thread
    assert_raises Sideband::SubThreadError do
      Thread.new { Sideband.initialize! }.join
    end
  end

  def test_has_queue
    assert_kind_of Queue, Sideband.queue
  end

  def test_has_thread
    assert_kind_of Sideband::Thread, Sideband.thread
  end

  def test_can_queue_proc
    skip 'implement me'
  end

  def test_fork_handling
    Sideband.initialize!
    queue  = Sideband.queue
    thread = Sideband.thread

    Process.stub(:pid, Process.pid + 1) do
      Sideband.queue << -> { 'work' }
      refute_equal queue,  Sideband.queue
      refute_equal thread, Sideband.thread
    end
  end

end
