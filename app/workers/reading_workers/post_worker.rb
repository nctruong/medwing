module ReadingWorkers
  class PostWorker
    include Sneakers::Worker
    from_queue RabbitmqServices::Reading::RABBITMQ_OPTIONS[:queues][:create],
               exchange: RabbitmqServices::Reading::RABBITMQ_OPTIONS[:exchange], durable: true

    def work(options)
      readings_json = JSON.parse(options)
      id = readings_json['id'].to_s
      # GET Process
      get(id, readings_json)

      # POST Process
      # Reading.create(JSON.parse(options))
      saved = Reading.create(JSON.parse(options))
      RedisServices::ReadingPool.remove(JSON.parse(options)['id']) if saved
      ack! if saved
    end

    private

    def get(id, readings_json)
      pool = RedisServices::ReadingPool
      puts "id##{id} exist ========================#{readings_json}================================#{pool.id_exists?(id)}"
      if pool.id_exists?(id)
        puts "set result for #{id}: #{readings_json}-------------------------------------------------"
        pool.set_result(id, readings_json)
      end
    end
  end
end