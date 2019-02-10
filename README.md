## Instruction

## Installation
- Redis
- RabbitMQ: http://www.rabbitmq.com/install-homebrew.html

### Test
- Starting redis first.
- Bundle exec rspec

- Why sneakers?
https://github.com/jondot/sneakers/wiki/Why-i-built-it#sneakers
https://blog.stanko.io/rabbitmq-is-more-than-a-sidekiq-replacement-b730d8176fb

http://www.rabbitmq.com/installing-plugins.html
https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/
rabbitmq-plugins enable rabbitmq_delayed_message_exchange

### Development
foreman start -f Procfile.dev