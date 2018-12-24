class ReadingWorker
  include Sneakers::Worker
  from_queue 'reading.create'

  def work(options)
    sleep 60
    Reading.create(options)
    # publish(doc.css('title').text, :to_queue => 'title_classification')
    ack!
  end
end