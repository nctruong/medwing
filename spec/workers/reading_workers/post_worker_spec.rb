require 'rails_helper'

RSpec.describe ReadingWorkers::PostWorker, type: :worker do
  include_context :reading_params
  include_context :worker_data

  let(:post_worker) { ReadingWorkers::PostWorker.new }

  describe 'valid' do

    before(:each) do
      Redis.current.flushall
      create_sample_data(thermostat_quantity: 20, reading_quantity: 100)
    end

    include_examples :expected_reading_order

    it 'saves successfully records to db' do
      Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:create]].each_with_index do |message, idx|
        post_worker.work(message)
        expect(Reading.count).to eq(idx + 1)
      end
    end

    it 'enqueues successfully records to delete later' do
      Sneakers::Testing.messages_by_queue["readings.create"].each_with_index do |message, idx|
        post_worker.work(message)
        expect(Sneakers::Testing.messages_by_queue[RabbitmqServices::Reading::OPTIONS[:queues][:delete]].count).to eq(idx + 1)
      end
    end
  end
end