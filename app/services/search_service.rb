# app/services/search_service.rb

class SearchService
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

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
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
      return { status: :ok, data: parse_response(cached) }
    end

    begin
      response = HTTParty.get(@url, headers: @options[:headers])

      case response.code
      when 200
        parsed_response = parse_response(response.body)
        @store.set(@url, response.body)
        @store.expire(@url, REDIS_TTL)
        { status: :ok, data: parsed_response }
      else
        { status: :error, error_message: response.message }
      end
    rescue HTTParty::Error => e
      { status: :error, error_message: e.message }
    end
  end

  def parse_response(response_body)
    @options[:html] ? Nokogiri::HTML(response_body) : JSON.parse(response_body)
  end
end
