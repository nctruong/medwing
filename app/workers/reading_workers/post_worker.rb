module ReadingWorkers
  class PostWorker
    include Sneakers::Worker
    from_queue RabbitmqServices::Reading::RABBITMQ_OPTIONS[:queues][:create],
               exchange: RabbitmqServices::Reading::RABBITMQ_OPTIONS[:exchange], durable: true,
               'x-queue-mode': 'lazy'

    def work(options)
      # readings_json = JSON.parse(options)
      # id = readings_json['id'].to_s
      # temp_saving(id, readings_json)

      saved = Reading.create(JSON.parse(options))
      RabbitmqServices::Reading.delete(id) if saved
      ack! if saved
    end

    # private
    #
    # def temp_saving(id, readings_json)
    #   pool = RedisServices::ReadingPool
    #   pool.set_result(id, readings_json) #if pool.id_exists?(id)
    # end
  end
end