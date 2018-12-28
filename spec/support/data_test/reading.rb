module DataTest
  class Reading
    module ClassMethods
      def create(num_of_thread = 5, records_for_each = 20)
        threads = []
        num_of_thread.times do
          thermostat = FactoryBot.create(:thermostat)
          threads << Thread.new { perform_job(thermostat.id, records_for_each) }
        end
        threads.each(&:join)
      end

      def all
        ::Reading.order_by_token_seq
      end

      private

      def perform_job(thermostat_id, quantity)
        quantity.times {
          ::ReadingJob.perform_now(attributes.merge(thermostat_id: thermostat_id))
        }
      end

      def attributes
        FactoryBot.attributes_for(:readings)
      end
    end
    extend ClassMethods
  end
end