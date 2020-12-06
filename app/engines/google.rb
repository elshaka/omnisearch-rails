class Google < Engine
  BASE_URL = 'https://customsearch.googleapis.com/customsearch/v1?cx=%s&key=%s&q=%s'.freeze
  ENGINE_ID = ENV['GOOGLE_ENGINE_ID']
  API_KEY = ENV['GOOGLE_API_KEY']

  def initialize(query)
    super(format(BASE_URL, ENGINE_ID, API_KEY, query))
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
