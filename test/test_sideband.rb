require 'helper'

class TestSideband < MiniTest::Unit::TestCase

  def test_must_be_initialized_before_use
    assert_raises Sideband::NotInitializedError do
      Sideband.queue << -> { 'work' }
    end
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

  def test_manager_stored_in_thread_current
    Sideband.initialize! do
      assert_kind_of Sideband::Manager, ::Thread.current['sideband.manager']
    end
  end

  def test_can_be_used_in_separate_threads
    work_a, work_b = 'work', 'work'
    Sideband.initialize! do
      Sideband.queue << -> { work_a = 'finished' }

      Thread.new {
        Sideband.initialize! do
          Sideband.queue << -> { work_b = 'finished' }
        end
      }.join
    end

    assert_equal 'finished', work_a
    assert_equal 'finished', work_b
  end
end
