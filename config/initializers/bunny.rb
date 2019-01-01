$bunny_conn = Bunny.new
$bunny_conn.start
publish_channel = $bunny_conn.create_channel
$post_queue = publish_channel.queue('readings.create', durable: true)