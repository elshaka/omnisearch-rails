class Bing < Engine
  BASE_URL = 'https://api.bing.microsoft.com/v7.0/search?q=%s'.freeze
  SUSCRIPTION_KEY = ENV['BING_SUSCRIPTION_KEY']

  def initialize(query)
    super(format(BASE_URL, query), headers: {
      'Ocp-Apim-Subscription-Key' => SUSCRIPTION_KEY
    })
  end

  def self.provider_name
    :bing
  end

  def self.map_data(_data)
    [] # Bing's API currently returns a 401 error
  end
end
