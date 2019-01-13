module ReadingWorkers
  class PostWorker
    include Sneakers::Worker

    from_queue RabbitmqServices::Reading::OPTIONS[:queues][:create],
               exchange: RabbitmqServices::Reading::OPTIONS[:exchange], durable: true,
               'x-queue-mode': 'lazy'

    def work(options)
      readings_json = JSON.parse(options)
      id = readings_json['id'].to_s
      saved = Reading.create(readings_json)
      RabbitmqServices::Reading.delete(id) if saved
      ack! if saved
    rescue
      error = WorkerMessage.create(worker: self.class, message: options)
      Rails.logger.warn { "#{self.class} encountered issues. Check #{error} for more info" }
    end
  end
end