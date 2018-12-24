module Helpers
  module Printer
    def print_row(options = {})
      puts sprintf(
         "%-11s%-11s%-11s",
         options[:reading_id] || "READING-ID",
         options[:order_number] || "ORDER",
         options[:household_token] || "TOKEN")
    end
  end
end