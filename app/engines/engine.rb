# app/engines/engine.rb

require 'net/http'

class Engine
  REDIS_TTL = 900

  attr_reader :url

  def initialize(url)
    @url = url
    @uri = URI(url)
    @store = Redis.new
  end

  def provider_name
    raise NotImplementedError
  end

  def results
    raise NotImplementedError
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
