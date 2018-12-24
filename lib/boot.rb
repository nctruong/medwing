require 'sneakers'
require 'redis'
require 'json'
require 'sneakers/metrics/logging_metrics'
Sneakers.configure(metrics: Sneakers::Metrics::LoggingMetrics.new)


$redis = Redis.new

class Processor
  include Sneakers::Worker
  from_queue :logs


  def work(msg)
    err = JSON.parse(msg)
    if err["type"] == "error"
      $redis.incr "processor:#{err["error"]}"
    end

    ack!
  end
end