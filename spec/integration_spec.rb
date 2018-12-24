require 'rails_helper'

RSpec.describe 'integration' do
  include Helpers::Printer

  before(:each) { DataTest::Reading.create }

  describe '#POST' do
    it 'creates exact 100 records by default' do
      expect(Reading.count).to eq(100)
    end

    it 'creates readings in order of sequences' do
      # print_row
      cur_idx = 1 ; cur_token = 'INIT'
      DataTest::Reading.all.each do |r|
        cur_idx, cur_token = sequence_token_pair(cur_token, cur_idx, r.thermostat.household_token)
        # print_row(reading_id: r.id, order_number: r.number, household_token: r.thermostat.household_token)
        expect(r.number).to eq(cur_idx)
      end
    end
  end

  private

  def sequence_token_pair(cur_token, cur_idx, new_token)
    if cur_token == new_token
      return [cur_idx + 1, new_token]
    else
      return [1, new_token]
    end
  end
end