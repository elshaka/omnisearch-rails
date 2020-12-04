# app/engines/engine.rb

require 'net/http'

class Engine
  REDIS_TTL = 900

  def initialize(url)
    @url = url
    @uri = URI(url)
    @store = Redis.new
  end

  def self.map_data(data)
    raise NotImplementedError
  end

  def provider_name
    raise NotImplementedError
  end

  def results
    response = perform_request
    {
      provider: provider_name,
      status: response[:status],
      error_message: response[:error_message],
      data: self.class.map_data(response[:data] || {})
    }
  end

  def perform_request
    if (cached = @store.get(@url))
      return { status: :ok, data: JSON.parse(cached) }
    end

    begin
      case response = Net::HTTP.get_response(@uri)
      when Net::HTTPSuccess
        @store.set(@url, response.body)
        @store.expire(@url, REDIS_TTL)
        { status: :ok, data: JSON.parse(response.body) }
      else
        { status: :error, error_message: response.message }
      end
    rescue StandardError => e
      { status: :error, error_message: e.message }
    end
  end
end
