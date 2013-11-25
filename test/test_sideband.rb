require 'helper'

class TestSideband < Minitest::Test

  def test_autoinitialization
    assert Sideband.queue << -> { 'work' }
  end

  def test_has_queue
    Sideband.initialize! do
      assert_kind_of Sideband::Queue, Sideband.queue
    end
  end

  def test_can_access_queue_or_send_jobs
    Sideband.initialize! do
      assert Sideband.queue(-> { 'work' })
      assert Sideband.enqueue(-> { 'work' })
    end
  end
end
