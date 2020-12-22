class BingSearch < SearchService
  BASE_URL = 'https://www.bing.com/search?q=%s'.freeze

  def initialize(query)
    user_agent = Rails.configuration.services_credentials[:bing][:user_agent]
    super(format(BASE_URL, query), headers: { 'User-Agent': user_agent })
  end

  def self.provider_name
    :bing
  end

  def self.parse_response(response_body)
    Nokogiri::HTML(response_body)
  end

  def self.map_data(data)
    (data.css('.b_algo h2 a') || []).map do |result|
      {
        title: result.children.to_s,
        link: result['href']
      }
    end
  end
end

# class BingSearch < SearchService
#   BASE_URL = 'https://api.bing.microsoft.com/v7.0/search?q=%s'.freeze
#
#   def initialize(query)
#     subscription_key = Rails.configuration.services_credentials[:bing][:subscription_key]
#     super(format(BASE_URL, query), headers: {
#       'Ocp-Apim-Subscription-Key' => subscription_key
#     })
#   end
#
#   def self.provider_name
#     :bing
#   end
#
#   def self.map_data(data)
#     data # Bing's JSON API currently returns a 401 error
#   end
# end
