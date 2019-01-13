module ReadingWorkers
  class DeleteWorker
    include Sneakers::Worker

    from_queue RabbitmqServices::Reading::OPTIONS[:queues][:delete],
               'x-queue-mode': 'lazy'

    def work(id)
      if reading_exists?(id)
        # logger.info { "#{self.class}: Deleting readings#id: #{id}" }
        RedisServices::ReadingPool.remove(id)
        ack!
      end
    end

    private

    def reading_exists?(id)
      Reading.find_by(id: id.to_i).present?
    end
  end
end