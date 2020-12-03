class Engine
  REDIS_TTL = 900

  def initialize(url)
    @url = url
    @uri = URI(url)
    @store = Redis.new
  end

  def get_provider_name
    raise NotImplementedError
  end

  def get_results
    raise NotImplementedError
  end

  def perform_request
    cached = @store.get(@url)
    return { status: :ok, data: JSON.parse(cached) } if cached

    case response = Net::HTTP.get_response(@uri)
    when Net::HTTPSuccess
      @store.set(@url, response.body)
      @store.expire(@url, REDIS_TTL)
      return { status: :ok, data: JSON.parse(response.body) }
    else
      return { status: :error, error_message: response.message }
    end
  end
end
