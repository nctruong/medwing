require 'httparty'
require 'json'

class QueueInspector
  include HTTParty
  basic_auth "guest", "guest"
  base_uri "http://localhost:15672"

  def messages
    body = {count: 5, ackmode:"ack_requeue_true", encoding:"auto", truncate:50000,
    vhost: '/', name: 'reading'}.to_json
    headers = {"Content-Type" => "application/json"}
    options = {body: body, headers: headers}
    self.class.post "/api/queues/vhost/name/get", options
  end
end

response = QueueInspector.new.messages
puts response.code
puts response.body