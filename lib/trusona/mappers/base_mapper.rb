# frozen_string_literal: true

module Trusona
  module Mappers
    #
    ## A starting point for specific resource mappers
    class BaseMapper
      include Trusona::Helpers::KeyNormalizer
      attr_accessor :custom_mappings, :resource

      def map(response, existing = {})
        raise ArgumentError if response_invalid?(response)
        raise ArgumentError if existing_invalid?(existing)

        raise if existing.nil?

        parsed_response = response.to_h

        if parsed_response.is_a?(Array)
          parsed_response.map { |r| map_item(r, existing) }.compact
        else
          map_item(parsed_response, existing)
        end
      end

      private

      def map_item(item, existing)
        return nil if item.nil? || item.empty?
        item = normalize_keys(item)
        item = merge_existing_state(item, existing.to_h)
        item = map_custom_fields(item)

        (resource || Trusona::Resources::BaseResource).send(:new, item)
      end

      def merge_existing_state(response, existing)
        existing.to_h.compact.merge(response)
      end

      def map_custom_fields(response)
        return response if custom_mappings.nil? || custom_mappings.empty?
        custom_mappings.each do |original_key, new_key|
          value = response.delete(original_key)
          response[new_key] = value
        end

        response
      end

      def response_invalid?(response)
        return true if response.nil?
        return true unless response.respond_to?(:to_h)
        false
      end

      def resource_invalid?(resource)
        return true if resource.nil?
        return true unless resource.respond_to?(:new)
        false
      end

      def existing_invalid?(existing)
        return true unless existing.respond_to?(:to_h)
        false
      end
    end
  end
end
