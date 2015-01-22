require 'helper'

class TestManager < Minitest::Test

  def setup
    @manager = Sideband::Manager.new
  end

  def test_has_queue
    assert_kind_of Sideband::Queue, @manager.queue
  end

  def test_has_thread
    assert_kind_of Sideband::Thread, @manager.thread
  end

  def test_can_queue_and_process_proc
    skip 'Testing thread scheduling is hard...'
    work = 'work'
    @manager.queue << -> { work = 'finished' }
    sleep 0.5
    assert_equal 'finished', work
  end

  def test_can_queue_and_process_worker
    skip 'Testing thread scheduling is hard...'
    worker = EmailWorker.new
    assert_equal 'work', worker.work
    @manager.queue << worker
    sleep 0.5
    assert_equal 'finished', worker.work
  end

  if !jruby?
    def test_fork_handling
      queue  = @manager.queue
      thread = @manager.thread

      Process.stub(:pid, Process.pid + 1) do
        @manager.queue << -> { 'work' }
        refute_equal queue,  @manager.queue
        refute_equal thread, @manager.thread
      end
    end
  end

  def test_killed
    @manager.kill
    assert_nil @manager.instance_variable_get(:@queue)
    assert_nil @manager.thread
  end

end
