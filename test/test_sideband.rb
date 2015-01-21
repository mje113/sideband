require 'helper'

class TestSideband < Minitest::Test

  def test_autoinitialization
    assert Sideband.queue << -> { 'work' }
  end

  def test_has_queue
    Sideband.initialize!
    assert_kind_of Sideband::Queue, Sideband.queue
  end

  def test_can_access_queue_or_send_jobs
    Sideband.initialize!
    assert Sideband.queue(-> { 'work' })
    assert Sideband.enqueue(-> { 'work' })
  end

  def test_sideband_execution_success
    $sideband_test_variable = 1

    Sideband.initialize!

    Sideband.queue(-> { $sideband_test_variable = 2 })
    Sideband.queue(-> { $sideband_test_variable = 3 })

    sleep 1

    assert_equal 3, $sideband_test_variable

    Sideband.queue << (-> { $sideband_test_variable = 4 })

    sleep 1

    assert_equal 4, $sideband_test_variable
  end
end
