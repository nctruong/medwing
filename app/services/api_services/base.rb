module ApiServices
  class Base
    include HTTParty
    base_uri "localhost:3000"

    def options
      { :headers => headers }
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end
  end
end