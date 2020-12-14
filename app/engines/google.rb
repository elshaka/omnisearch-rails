class Google < Engine
  BASE_URL = 'https://customsearch.googleapis.com/customsearch/v1?cx=%s&key=%s&q=%s'.freeze

  def initialize(query)
    engine_id = Rails.configuration.services_credentials['google']['engine_id']
    api_key = Rails.configuration.services_credentials['google']['api_key']
    super(format(BASE_URL, engine_id, api_key, query))
  end

  def self.provider_name
    :google
  end

  def self.map_data(data)
    (data['items'] || []).map do |item|
      { title: item['title'], link: item['link'] }
    end
  end
end
