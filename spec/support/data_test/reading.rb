module DataTest
  class Reading
    module ClassMethods
      def create(records)
        reading_service = ApiServices::ReadingService.new
        10.times { FactoryBot.create(:thermostat) }
        records.times do
          id = reading_service.post(attributes.merge(thermostat_id: Thermostat.all.sample.id))
          puts id
        end
      end

      def all
        ::Reading.order_by_token_seq
      end

      private

      def attributes
        FactoryBot.attributes_for(:reading)
      end
    end
    extend ClassMethods
  end
end