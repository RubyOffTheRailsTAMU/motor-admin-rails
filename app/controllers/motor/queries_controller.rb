# frozen_string_literal: true

module Motor
  class QueriesController < ApiBaseController
    load_and_authorize_resource :query, only: %i[index show update destroy]

    before_action :build_query, only: :create
    authorize_resource :query, only: :create

    def index
      render json: { data: Motor::ApiQuery::BuildJson.call(@queries, params) }
    end

    def show
      render json: { data: Motor::ApiQuery::BuildJson.call(@query, params) }
    end

    def create
      if Motor::Queries.name_already_exists?(@query)
        render json: { error: { name: ['already exists'] } }, status: :unprocessable_entity
      else
        ApplicationRecord.transaction { @query.save! }

        render json: { data: Motor::ApiQuery::BuildJson.call(@query, params) }
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def update
      Motor::Queries.update_from_params!(@query, query_params)

      render json: { data: Motor::ApiQuery::BuildJson.call(@query, params) }
    rescue Motor::Queries::NameAlreadyExists
      render json: { error: { name: ['already exists'] } }, status: :unprocessable_entity
    end

    def destroy
      @query.update!(deleted_at: Time.current)

      head :ok
    end

    private

    def build_query
      @query = Motor::Queries.build_from_params(query_params)
    end

    def query_params
      params.require(:data).permit(:name, :sql_body, :description, preferences: {}, tags: [])
    end
  end
end