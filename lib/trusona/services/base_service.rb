# frozen_string_literal: true

module Trusona
  module Services
    #
    ## The starting point for building other services that interact with the
    ## Trusona API
    class BaseService
      attr_accessor :resource_path

      def initialize(client: Trusona::Api::HTTPClient.new,
                     mapper: Trusona::Mappers::BaseMapper.new)
        @client = client
        @mapper = mapper
        @resource_path = '/base-service'
      end

      def index
        handle(@client.get(collection_path))
      end

      def get(resource)
        raise Trusona::InvalidResourceError unless resource.id
        handle(@client.get(member_path(resource)), resource)
      end

      def create(resource)
        puts resource.to_json
        raise Trusona::InvalidResourceError unless resource.valid?
        handle(@client.post(collection_path, resource.to_json), resource)
      end

      def update(resource)
        raise Trusona::InvalidResourceError unless resource.id
        handle(@client.patch(member_path(resource), resource.to_json), resource)
      end

      def delete(resource)
        raise Trusona::InvalidResourceError unless resource.id
        handle(@client.delete(member_path(resource)), resource)
      end

      def collection_path
        @resource_path
      end

      def member_path(resource)
        [collection_path, resource.id].join('/')
      end

      private

      def verify_response(response)
        raise Trusona::SigningError unless response.verified?
      end

      # rubocop:disable MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def handle(response, resource = {})
        @response = response
        raise if resource.nil?
        case response.code
        when 200..299
          success(response, resource)
        when 400
          bad_request
        when 404
          not_found
        when 403
          unauthorized
        when 424
          failed_dependency
        when 500..599
          server_error
        else
          raise Trusona::RequestError, readable_error
        end
      end
      # rubocop:enable MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      def success(response, resource)
        verify_response(response)
        @mapper.map(response, resource)
      end

      def bad_request
        raise Trusona::BadRequestError, readable_error
      end

      def failed_dependency
        raise Trusona::FailedDependencyError, readable_error
      end

      def not_found
        raise Trusona::ResourceNotFoundError, readable_error
      end

      def unauthorized
        raise Trusona::UnauthorizedRequestError, readable_error
      end

      def server_error
        raise Trusona::ApiError
      end

      def readable_error
        default = '[UNKNOWN] Error - An unknown error has occurred.'
        return default unless @response
        body = @response.to_h
        msg = []
        msg << "[#{body['error']}] #{body['message']} - #{body['description']}"
        return msg.join("\n") unless body['field_errors']
        body['field_errors'].each do |field|
          msg << "\t #{field.join(' => ')}"
        end

        msg.join("\n")
      end
    end
  end
end
