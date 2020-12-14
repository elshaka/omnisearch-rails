# app/models/search.rb
class Search
  ENGINE_OPTIONS = %w[google bing both].freeze

  include ActiveModel::Validations

  attr_accessor :engine, :text

  validates :engine, inclusion: {
    in: ENGINE_OPTIONS,
    message: "%{value} is not a valid engine option. Valid engine options: #{ENGINE_OPTIONS}"
  }
  validates :text, presence: true

  def initialize(params = {})
    @engine = params[:engine]
    @text = params[:text]
  end

  def results
    return nil unless valid?

    engines = case engine
              when 'both'
                [Google.new(text), Bing.new(text)]
              else
                [engine.capitalize.constantize.new(text)]
              end

    self.class.agreggate_engines_responses(engines)
  end

  def self.agreggate_engines_responses(engines)
    engines_results = engines.map(&:results)

    {
      status: aggregate_engines_statuses(engines_results),
      status_by_provider: aggregate_providers_statuses(engines_results),
      results: aggregate_engines_results(engines_results)
    }
  end

  def self.aggregate_engines_statuses(engines_results)
    engines_results.any? { |engine_results| engine_results[:status] == :ok } ? :ok : :service_unavailable
  end

  def self.aggregate_providers_statuses(engines_results)
    engines_results.map do |engine_results|
      {
        provider: engine_results[:provider],
        status: engine_results[:status],
        error_messages: engine_results[:error_messages]
      }
    end
  end

  def self.aggregate_engines_results(engines_results)
    engines_results.map do |engine_results|
      engine_results[:data].map do |results|
        {
          provider: engine_results[:provider],
          title: results[:title],
          link: results[:link]
        }
      end
    end.flatten
  end
end
