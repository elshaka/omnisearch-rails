class Bing < Engine
  BASE_URL = 'https://api.bing.microsoft.com/v7.0/search?q=%s'.freeze

  def initialize(query)
    subscription_key = Rails.configuration.services_credentials['bing']['subscription_key']
    super(format(BASE_URL, query), headers: {
      'Ocp-Apim-Subscription-Key' => subscription_key
    })
  end

  def self.provider_name
    :bing
  end

  def self.map_data(_data)
    [] # Bing's API currently returns a 401 error
  end
end
