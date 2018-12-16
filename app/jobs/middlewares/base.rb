# Stores jobs in custom queue (db): allocate to execute jobs
#
# problems:
# - job failed => how to perform next jobs? => failed || successful, next job
# - keep job in queue?
#
module Middleware
  class Base

  end
end