class Engine
  REDIS_TTL = 900

  attr_reader :success

  def initialize(url)
    @url = url
    @success = false
    @store = Redis.new
  end

  def perform_request
    cached = @store.get(@url)
    if cached
      @success = true
      @response = JSON.parse(cached)
    else
      http_response = HTTParty.get(@url)
      @success = http_response.success?

      if @success
        @store.set(@url, http_response.body)
        @store.expire(@url, REDIS_TTL)
        @response = http_response.parsed_response
      end
    end
  end

  def get_results
    raise NotImplementedError
  end
end
