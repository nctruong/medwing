conn = Bunny.new
conn.start
publish_channel = conn.create_channel
$post_queue = publish_channel.queue('readings.create', durable: true)

$delayed_exchange = Bunny::Exchange.new(publish_channel, 'x-delayed-message', 'delayed.exchange', {
    type: 'x-delayed-message',
    arguments: { 'x-delayed-type' => 'direct' },
    durable: true,
    auto_delete: false
})