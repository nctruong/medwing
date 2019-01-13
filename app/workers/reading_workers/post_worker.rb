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
    end
  end
end