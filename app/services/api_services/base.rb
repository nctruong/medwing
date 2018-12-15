module ApiServices
  class Base
    include HTTParty
    base_uri "localhost:3000"
  end
end