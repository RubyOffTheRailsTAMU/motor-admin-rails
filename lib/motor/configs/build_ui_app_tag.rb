# frozen_string_literal: true

module Motor
  module Configs
    module BuildUiAppTag
      CACHE_STORE =
        if Motor.development?
          ActiveSupport::Cache::NullStore.new
        else
          ActiveSupport::Cache::MemoryStore.new(size: 5.megabytes)
        end

      module_function

      def call
        cache_keys = LoadFromCache.load_cache_keys

        CACHE_STORE.fetch(cache_keys.hash) do
          CACHE_STORE.clear

          Motor::ApplicationController.helpers.content_tag(
            :div, '', id: 'app', data: build_data(cache_keys)
          )
        end
      end

      # @return [Hash]
      def build_data(cache_keys = {})
        {
          base_path: Motor::Admin.routes.url_helpers.motor_path,
          schema: Motor::BuildSchema.call(cache_keys),
          header_links: header_links_data_hash(cache_keys[:configs]),
          queries: queries_data_hash(cache_keys[:queries]),
          dashboards: dashboards_data_hash(cache_keys[:dashboards]),
          alerts: alerts_data_hash(cache_keys[:alerts]),
          forms: forms_data_hash(cache_keys[:forms])
        }
      end

      def header_links_data_hash(cache_key = nil)
        configs = Motor::Configs::LoadFromCache.load_configs(cache_key: cache_key)

        configs.find { |c| c.key == 'header.links' }&.value || []
      end

      def queries_data_hash(cache_key = nil)
        Motor::Configs::LoadFromCache.load_queries(cache_key: cache_key)
                                     .as_json(only: %i[id name updated_at],
                                              include: { tags: { only: %i[id name] } })
      end

      def dashboards_data_hash(cache_key = nil)
        Motor::Configs::LoadFromCache.load_dashboards(cache_key: cache_key)
                                     .as_json(only: %i[id title updated_at],
                                              include: { tags: { only: %i[id name] } })
      end

      def alerts_data_hash(cache_key = nil)
        Motor::Configs::LoadFromCache.load_alerts(cache_key: cache_key)
                                     .as_json(only: %i[id name is_enabled updated_at],
                                              include: { tags: { only: %i[id name] } })
      end

      def forms_data_hash(cache_key = nil)
        Motor::Configs::LoadFromCache.load_forms(cache_key: cache_key)
                                     .as_json(only: %i[id name updated_at],
                                              include: { tags: { only: %i[id name] } })
      end
    end
  end
end