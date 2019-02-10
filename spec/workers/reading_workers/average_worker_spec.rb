require 'rails_helper'

RSpec.describe ReadingWorkers::PostWorker, type: :worker do
  let!(:thermostat) { create(:thermostat) }
  let(:average_worker) { ReadingWorkers::AverageWorker.new }

  include_context :testing_data

  before(:each) do
    create_data_for_average(thermostat)
    # simulating first message in queue
    ReadingWorkers::AverageWorker.new.work(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:create]].first)
    @result = JSON.parse RedisServices::ReadingPool.average.gsub('=>',':')
  end

  describe 'valid' do
    include_examples :expected_reading_order

    include_examples :expected_average
  end
end