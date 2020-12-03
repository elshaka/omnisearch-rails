class Google < Engine
  BASE_URL = 'https://customsearch.googleapis.com/customsearch/v1?cx=%s&key=%s&q=%s'.freeze
  ENGINE_ID = ENV['GOOGLE_ENGINE_ID']
  API_KEY = ENV['GOOGLE_API_KEY']

  def initialize(query)
    super(format(BASE_URL, ENGINE_ID, API_KEY, query))
  end

  def provider_name
    :google
  end

  def results
    response = perform_request
    {
      provider: provider_name,
      status: response[:status],
      error_message: response[:error_message],
      data: map_items(response.dig(:data, 'items'))
    }
  end

  def map_items(items)
    (items || []).map do |item|
      { title: item['title'], link: item['link'] }
    end
  end
end
