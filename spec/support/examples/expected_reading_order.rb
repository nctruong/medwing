module Support
  module Examples
    module Reading
      RSpec.shared_examples :expected_reading_order do
        include Helpers::Printer

        it 'creates reading records in order' do
          cur_idx = 1 ; cur_token = 'INIT'
          ::Reading.order_by_token_seq.each do |r|
            cur_idx, cur_token = sequence_token_pair(cur_token, cur_idx, r.thermostat.household_token)
            # print_row(reading_id: r.id, order_number: r.number, household_token: r.thermostat.household_token)
            expect(r.number).to eq(cur_idx)
          end
        end

        private

        def sequence_token_pair(cur_token, cur_idx, new_token)
          cur_idx = cur_token == new_token ? (cur_idx + 1) : 1
          [cur_idx, new_token]
        end
      end

      RSpec.shared_examples :expected_average do
        describe '#average' do
          it 'returns 30 as the average of temperature' do
            expect(@result['temperature']).to eq(30)
          end

          it 'returns 40 as the average of humidity' do
            expect(@result['humidity']).to eq(40)
          end

          it 'returns 50 as the average of battery charge' do
            expect(@result['battery_charge']).to eq(50)
          end
        end
      end
    end
  end
end