# app/models/search.rb
class Search
  ENGINE_OPTIONS = %w[google].freeze

  include ActiveModel::Validations

  attr_accessor :engine, :text

  validates :engine, inclusion: {
    in: ENGINE_OPTIONS,
    message: "%{value} is not a valid engine option. Valid engine options: #{ENGINE_OPTIONS}"
  }
  validates :text, presence: true

  def initialize(params)
    @engine = params[:engine]
    @text = params[:text]
  end

  def results
    return false unless valid?

    engines = case engine
              when 'both'
                [Google.new(text)]
              else
                [engine.capitalize.constantize.new(text)]
              end

    engines_results = engines.map(&:results)
    status = engines_results.any? { |engine_results| engine_results[:status] == :ok } ? :ok : :service_unavailable

    { status: status, engines_results: engines_results }
  end
end
