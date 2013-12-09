# Sideband

[![Build Status](https://api.travis-ci.org/mje113/sideband.png)](http://travis-ci.org/mje113/sideband)
[![Code Climate](https://codeclimate.com/github/mje113/sideband.png)](https://codeclimate.com/github/mje113/sideband)
[![Coverage Status](https://coveralls.io/repos/mje113/sideband/badge.png)](https://coveralls.io/r/mje113/sideband)
[![Dependency Status](https://gemnasium.com/mje113/sideband.png)](https://gemnasium.com/mje113/sideband)

Run simple jobs in a separate sideband thread.

Sideband makes it easy to pass small jobs off to a separate in-process thread. It makes no attempt to handle errors, nor return any results. Its primary focus is queueing up potentially IO blocking bits of code, where the results of which are not necessarily vital to your application's business logic.

## Installation

Add this line to your application's Gemfile:

    gem 'sideband'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sideband

## Usage

To be used Sideband needs to be intialized, typically in an Rails initializer (but can be used outside of Rails).

```ruby
Sideband.initialize!
```

To pass work off to Sideband, you can add anything that is callable (procs, lambdas, workers) to its queue:

```ruby
Sideband.queue << -> { Something.expensive }
```

Sideband will queue the work, then return immediately.  The work will get called whenever the thread scheduler schedules the worker thread--typically after your controller renders.

Sideband is truly fire-and-forget, any exceptions are caught and thrown away.  If you want to handle exception, you should probably do so in a custom worker.

```ruby
class MetricWorker < Sideband::Worker
  def initialize(params)
    @params = params
  end

  def call
    Metric.create!(@params)
  rescue ActiveRecord::RecordInvalid
    Rails.logger.error("Could not save Metric: #{@params}")
  end
end

Sideband.queue << MetricWorker.new(params[:metric])

 # or Sideband::Workers can enqueue themselves

Metricworker.new(params[:metric]).enqueue
```

A practical Rails example:
```ruby
class UsersController < ApplicationController

  def create
    @user = User.create(params[:user])
    Sideband.queue << -> { UserMailer.welcome_email(@user).deliver }
    render :welcome
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/mje113/sideband/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

