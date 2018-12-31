require 'rails_helper'

RSpec.describe ReadingWorkers, type: :worker do
  it 'receives messages after 1 second of delay'
  it 'deletes Redis key successfully'
end