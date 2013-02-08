require 'helper'

class TestQueue < MiniTest::Unit::TestCase

  def setup
    @queue = Sideband::Queue.new
  end

  def test_killed
    @queue.kill
    assert_nil @queue.pop
  end

  def test_can_push_and_pop
    assert_equal true, @queue.push(:a)
    assert_equal :a,   @queue.pop
  end

  def test_nil_blocked
    refute @queue << nil
  end
end
