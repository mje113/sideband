require 'minitest/autorun'
require 'sideband'

class EmailWorker < Sideband::Worker
  def call
    'do some work'
  end
end
