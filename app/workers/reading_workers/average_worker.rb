module ReadingWorkers
  class AverageWorker
    include Sneakers::Worker

    from_queue RabbitmqServices::Reading::OPTIONS[:queues][:create],
               exchange: RabbitmqServices::Reading::OPTIONS[:exchange], durable: true,
               'x-queue-mode': 'lazy'

    # no @ack here so it only processes once per message.
    # Each time of getting new message it calculate the average.
    def work(options)
      readings_json = JSON.parse(options)
      id = readings_json['thermostat_id'].to_s
      result = CalculatorServices::ReadingService.average(['temperature', 'humidity', 'battery_charge'], { thermostat_id: id })
      RedisServices::ReadingPool.set_average(result)
    # rescue => e
    #   error = WorkerMessage.create(worker: self.class, message: options, error_message: e.to_s)
    #   Rails.logger.warn { "#{self.class} encountered issues. Check #{error} for more info" }
    end
  end
end