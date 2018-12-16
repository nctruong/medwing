require 'spec/rails_helper'

RSpec.describe Middleware::ReadingQueue, type: :job do
  describe 'valid' do
    it 'has only one instance existing in sidekiq queue at moment'
    it 'involves another job after success'

    describe '#dequeue' do
      it 'checks if no job is existing in sidekiq queue'
      it 'pushes a job to sidekiq queue'
      it ''
    end

    describe '#enqueue' do
      it ''
    end

  end

  describe 'invalid' do
    it 'involves another job after failure'
  end
end
