unless Rails.env.test?
  begin
    $bunny_conn = Bunny.new
    $bunny_conn.start
    publish_channel = $bunny_conn.create_channel
    $post_queue = publish_channel.queue('readings.create', durable: true)
  rescue
    message = 'Please start rabbitmq server'
    Rails.logger.warn { message }
    raise message
  end
end