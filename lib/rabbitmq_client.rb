require 'byebug'
require "rabbitmq/http/client"

client = RabbitMQ::HTTP::Client.new("http://guest:guest@127.0.0.1:15672")

# Fetch messages from a queue
ms = client.get_messages('/', 'reading.create', count:100, ackmode:"ack_requeue_true", encoding:"auto", truncate:50000)
m  = ms.first

puts ms