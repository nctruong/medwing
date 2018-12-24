class ReadingJob < ApplicationJob
  queue_as 'create'

  def perform(options)
    sleep 60
    Reading.create(options)
  end
end
