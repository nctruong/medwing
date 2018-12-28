require 'logger'

@rabbitmq_logger = Logger.new(Rails.root.join('log/rabbitmq.log'))
@rabbitmq_logger.level = Logger::INFO