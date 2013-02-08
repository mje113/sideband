require 'helper'

class TestWorker < MiniTest::Unit::TestCase

  def test_can_queue_itself
    assert Sideband::Worker.new.enqueue
    assert Sideband::Worker.new.queue
  end

  def test_raises_error_if_call_not_implemented
    assert_raises NotImplementedError do
      Sideband::Worker.new.call
    end
  end

  def test_call_implemented
    assert_equal 'do some work', EmailWorker.new.call
  end

end
