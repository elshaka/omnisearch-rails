# app/engines/engine.rb

require 'net/http'

class Engine
  REDIS_TTL = 900

  def initialize(url, options = {})
    redis_url = Rails.configuration.redis['url']

    @url = url
    @uri = URI(url)
    @store = redis_url ? Redis.new(url: redis_url) : Redis.new
    @options = options
  end

  def self.map_data(data)
    raise NotImplementedError
  end

  def self.provider_name
    raise NotImplementedError
  end

  def results
    response = perform_request
    {
      provider: self.class.provider_name,
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
      response = HTTParty.get(@url, headers: @options[:headers])

      case response.code
      when 200
        @store.set(@url, response.body)
        @store.expire(@url, REDIS_TTL)
        { status: :ok, data: response.parsed_response }
      else
        { status: :error, error_message: response.message }
      end
    rescue HTTParty::Error => e
      { status: :error, error_message: e.message }
    end
  end
end
