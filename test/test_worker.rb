require 'helper'

class TestWorker < Minitest::Test

  def test_can_queue_itself
    Sideband.initialize! do
      assert Sideband::Worker.new.enqueue
      assert Sideband::Worker.new.queue
      assert EmailWorker.new.enqueue
      assert EmailWorker.new.queue
    end
  end

  def test_raises_error_if_call_not_implemented
    assert_raises NotImplementedError do
      Sideband::Worker.new.call
    end
  end

  def test_call_implemented
    assert_equal 'finished', EmailWorker.new.call
  end

end
