# app/engines/engine.rb

require 'net/http'

class Engine
  REDIS_TTL = 900
  REDIS_URL = ENV['REDIS_URL']

  def initialize(url, options = {})
    @url = url
    @uri = URI(url)
    @store = REDIS_URL ? Redis.new(url: REDIS_URL) : Redis.new
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
      request = Net::HTTP::Get.new(@uri)
      if (headers = @options[:headers])
        headers.each { |key, value| request[key] = value }
      end
      response = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
        http.request(request)
      end

      case response
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
