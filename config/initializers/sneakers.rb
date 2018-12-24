require 'sneakers'
Sneakers.configure :amqp => 'amqp://guest:guest@127.0.0.1:5672',
    :vhost => '/',
    :exchange => 'medwing',
    :exchange_type => :direct,
    :timeout_job_after => 120       # Maximal seconds to wait for job
    # :prefetch => 10,              # Grab 10 jobs together. Better speed.
    # :threads => 10,               # Threadpool size (good to match prefetch)
    # :env => ENV['RACK_ENV'],      # Environment
    # :durable => true,             # Is queue durable?
    # :ack => true,                 # Must we acknowledge?
    # :heartbeat => 2,              # Keep a good connection with broker
    # :hooks => {},                 # prefork/postfork hooks
    # :start_worker_delay => 10     # Delay between thread startup

# daemonize: true,
# amqp: "amqp://rabbitmq",
# log: "log/sneakers.log",
# pid_path: "tmp/pids/sneakers.pid",
# threads: 1,
# workers: 1,
# exchange: 'dostuff',
# exchange_type: 'direct'

# Sneakers.logger.level = Logger::INFO # the default DEBUG is too noisy