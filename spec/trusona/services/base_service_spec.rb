# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Trusona::Services::BaseService do
  before do
    Trusona.config do |c|
      c.api_host = 'https://testing.local'
    end

    @widgets_service = Trusona::Services::BaseService.new
    @widgets_service.resource_path = '/widgets'

    @error_hash = {
      'message'     => 'a message',
      'error'       => 'an error',
      'description' => 'the description'
    }

    @server_busy_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      code: 503,
      verified?: true
    )

    @server_is_a_teapot_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      to_h: @error_hash,
      code: 418,
      verified?: true
    )

    @unauthorized_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      to_h: @error_hash,
      code: 403,
      verified?: true
    )

    @internal_server_error_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      code: 500,
      verified?: true
    )

    @bad_request_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      to_h: @error_hash,
      code: 400,
      verified?: true
    )

    @not_found_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      to_h: @error_hash,
      code: 404,
      verified?: true
    )

    @unprocessable_entity_response = double(
      Trusona::Api::VerifiedResponse,
      success?: false,
      to_h: @error_hash,
      code: 422,
      verified?: true
    )

    @failed_dependency_response = double(
      Trusona::Api::VerifiedResponse,
      to_h: @error_hash,
      success?: false,
      code: 424,
      verified?: true
    )

    @unverified_response_double = double(
      Trusona::Api::VerifiedResponse,
      code: 200,
      verified?: false
    )

    @verified_response_double = double(
      Trusona::Api::VerifiedResponse,
      code: 200,
      verified?: true
    )
  end

  describe 'intializing' do
    it 'should accept a custom client' do
      Trusona::Services::BaseService.new(client: double)
    end

    it 'should accept a custom mapper' do
      Trusona::Services::BaseService.new(mapper: double)
    end

    it 'should use a default client and mapper' do
      Trusona::Services::BaseService.new
    end
  end

  describe 'routing' do
    it 'should know the resource path' do
      expect(@widgets_service.resource_path).to eq('/widgets')
    end

    it 'should know how to access the collection endpoint' do
      expect(@widgets_service.collection_path).to eq('/widgets')
    end

    it 'should know how to access the member endpoint' do
      resource = double(id: 'resource-1')

      expect(@widgets_service.member_path(resource)).to eq('/widgets/resource-1')
    end
  end

  describe 'fetching a resource' do
    it 'should raise an error if the resource is missing an id' do
      sut = Trusona::Services::BaseService.new
      resource = double(id: nil)

      expect { sut.get(resource) }.to raise_error(Trusona::InvalidResourceError)
    end

    it 'should tell the client to GET the resource' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(client: client, mapper: mapper)
      sut.resource_path = '/widgets'

      expect(client).to receive(:get).with('/widgets/resource-1').and_return(
        @verified_response_double
      )
      sut.get(resource)
    end

    it 'should tell the mapper to map the response' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double
      sut = Trusona::Services::BaseService.new(
        client: client,
        mapper: mapper
      )

      allow(client).to receive(:get).and_return(@verified_response_double)

      expect(mapper).to receive(:map).with(@verified_response_double, resource)
      sut.get(resource)
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        resource = double(id: 'resource-1')
        client = double
        mapper = double(map: Object.new)
        sut = Trusona::Services::BaseService.new(
          client: client,
          mapper: mapper
        )

        allow(client).to receive(:get).and_return(@unverified_response_double)
        expect { sut.get(resource) }.to raise_error(Trusona::SigningError)
      end
    end

    context 'when the request fails' do
      before do
        @valid_resource = double(valid?: true, id: 1)
      end
      context 'for an unknown reason' do
        it 'should raise an error' do
          client = double(get: @server_is_a_teapot_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::RequestError,
              '[an error] a message - the description'
            )
          )
        end
      end
      context 'because it was unauthorized' do
        it 'should raise an error' do
          client = double(get: @unauthorized_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::UnauthorizedRequestError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because the request was malformed' do
        it 'should raise an error' do
          client = double(get: @bad_request_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::BadRequestError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because the resource could not be found' do
        it 'should raise an error' do
          client = double(get: @not_found_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::ResourceNotFoundError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because of an unprocessable entity (422)' do
        it 'should raise an error' do
          client = double(get: @unprocessable_entity_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::UnprocessableEntityError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because of a failed dependency' do
        it 'should raise an error' do
          client = double(get: @failed_dependency_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(
              Trusona::FailedDependencyError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because of a server error' do
        it 'should raise an error' do
          client = double(get: @internal_server_error_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end

      context 'because the server is unavailable' do
        it 'should raise an error' do
          client = double(get: @server_busy_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end
    end
  end

  describe 'creating resources' do
    before do
      @verified_response_double = double(code: 201, verified?: true)
    end

    it 'should raise an error if the resource is invalid' do
      sut = Trusona::Services::BaseService.new
      resource = double(valid?: false)

      expect { sut.create(resource) }.to(
        raise_error(Trusona::InvalidResourceError)
      )
    end

    it 'should tell the client to POST the resource' do
      resource = double(
        valid?: true,
        id: 'resource-1',
        to_json: JSON(id: 'resource-1')
      )
      client = double
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(client: client, mapper: mapper)
      sut.resource_path = '/widgets'

      expect(client).to receive(:post).with(
        '/widgets', resource.to_json
      ).and_return(@verified_response_double)
      sut.create(resource)
    end

    it 'should tell the mapper to map the response' do
      resource = double(valid?: true, id: 'resource-1')
      client = double
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(
        client: client,
        mapper: mapper
      )

      allow(client).to receive(:post).and_return(@verified_response_double)

      expect(mapper).to receive(:map).with(@verified_response_double, resource)
      sut.create(resource)
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        resource = double(valid?: true, id: 'resource-1')
        client = double
        mapper = double(map: Object.new)
        sut = Trusona::Services::BaseService.new(
          client: client,
          mapper: mapper
        )

        allow(client).to receive(:post).and_return(@unverified_response_double)
        expect { sut.create(resource) }.to raise_error(Trusona::SigningError)
      end
    end

    context 'when the request fails' do
      before do
        @valid_resource = double(valid?: true)
      end
      context 'for an unknown reason' do
        it 'should raise an error' do
          client = double(post: @server_is_a_teapot_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::RequestError)
          )
        end
      end
      context 'because it was unauthorized' do
        it 'should raise an error' do
          client = double(post: @unauthorized_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::UnauthorizedRequestError)
          )
        end
      end

      context 'because the request was malformed' do
        it 'should raise an error' do
          client = double(post: @bad_request_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::BadRequestError)
          )
        end
      end

      context 'because the resource could not be found' do
        it 'should raise an error' do
          client = double(post: @not_found_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::ResourceNotFoundError)
          )
        end
      end

      context 'because of a server error' do
        it 'should raise an error' do
          client = double(post: @internal_server_error_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end

      context 'because the server is unavailable' do
        it 'should raise an error' do
          client = double(post: @server_busy_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.create(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end
    end
  end

  describe 'fetching a collection' do
    before do
      @verified_response_double = double(Trusona::Api::VerifiedResponse, code: 200, verified?: true)
    end

    it 'should tell the client to GET the collection' do
      resources = [double(id: 'resource-1')]
      client = double(get: @verified_response_double)
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(client: client, mapper: mapper)
      sut.resource_path = '/widgets'

      expect(client).to receive(:get).with('/widgets').and_return(
        @verified_response_double
      )
      sut.index
    end

    it 'should tell the mapper to map the response' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double
      sut = Trusona::Services::BaseService.new(
        client: client,
        mapper: mapper
      )

      allow(client).to receive(:get).and_return(@verified_response_double)

      expect(mapper).to receive(:map).with(@verified_response_double, {})
      sut.index
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        resource = double(id: 'resource-1')
        client = double
        mapper = double(map: Object.new)
        sut = Trusona::Services::BaseService.new(
          client: client,
          mapper: mapper
        )

        allow(client).to receive(:get).and_return(@unverified_response_double)
        expect { sut.index }.to raise_error(Trusona::SigningError)
      end
    end

    context 'when the request fails' do
      before do
        @valid_resource = double(valid?: true, id: 1)
      end
      context 'for an unknown reason' do
        it 'should raise an error' do
          client = double(get: @server_is_a_teapot_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::RequestError)
          )
        end
      end
      context 'because it was unauthorized' do
        it 'should raise an error' do
          client = double(get: @unauthorized_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::UnauthorizedRequestError)
          )
        end
      end

      context 'because the request was malformed' do
        it 'should raise an error' do
          client = double(get: @bad_request_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::BadRequestError)
          )
        end
      end

      context 'because the resource could not be found' do
        it 'should raise an error' do
          client = double(get: @not_found_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::ResourceNotFoundError)
          )
        end
      end

      context 'because of a server error' do
        it 'should raise an error' do
          client = double(get: @internal_server_error_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end

      context 'because the server is unavailable' do
        it 'should raise an error' do
          client = double(get: @server_busy_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.get(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end
    end
  end

  describe 'updating a resource' do
    it 'should raise an error if the resource is missing an id' do
      sut = Trusona::Services::BaseService.new
      resource = double(id: nil)

      expect { sut.update(resource) }.to(
        raise_error(Trusona::InvalidResourceError)
      )
    end

    it 'should tell the client to PATCH the resource' do
      resource = double(id: 'resource-1', to_json: JSON(name: 'resource'))
      client = double
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(client: client, mapper: mapper)
      sut.resource_path = '/widgets'

      expect(client).to(
        receive(:patch).with('/widgets/resource-1', resource.to_json)
      ).and_return(
        @verified_response_double
      )
      sut.update(resource)
    end

    it 'should tell the mapper to map the response' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double
      sut = Trusona::Services::BaseService.new(
        client: client,
        mapper: mapper
      )

      allow(client).to receive(:patch).and_return(@verified_response_double)

      expect(mapper).to receive(:map).with(@verified_response_double, resource)
      sut.update(resource)
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        resource = double(id: 'resource-1')
        client = double
        mapper = double(map: Object.new)
        sut = Trusona::Services::BaseService.new(
          client: client,
          mapper: mapper
        )

        allow(client).to receive(:patch).and_return(@unverified_response_double)
        expect { sut.update(resource) }.to raise_error(Trusona::SigningError)
      end
    end

    context 'when the request fails' do
      before do
        @valid_resource = double(valid?: true, id: 1)
      end
      context 'for an unknown reason' do
        it 'should raise an error' do
          client = double(patch: @server_is_a_teapot_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::RequestError)
          )
        end
      end
      context 'because it was unauthorized' do
        it 'should raise an error' do
          client = double(patch: @unauthorized_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::UnauthorizedRequestError)
          )
        end
      end

      context 'because the request was malformed' do
        it 'should raise an error' do
          client = double(patch: @bad_request_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::BadRequestError)
          )
        end
      end

      context 'because the resource could not be found' do
        it 'should raise an error' do
          client = double(patch: @not_found_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::ResourceNotFoundError)
          )
        end
      end

      context 'because of a server error' do
        it 'should raise an error' do
          client = double(patch: @internal_server_error_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end

      context 'because the server is unavailable' do
        it 'should raise an error' do
          client = double(patch: @server_busy_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.update(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end
    end
  end

  describe 'deleting a resource' do
    it 'should raise an error if the resource is missing an id' do
      sut = Trusona::Services::BaseService.new
      resource = double(id: nil)

      expect { sut.delete(resource) }.to raise_error(Trusona::InvalidResourceError)
    end

    it 'should tell the client to DELETE the resource' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double(map: Object.new)
      sut = Trusona::Services::BaseService.new(client: client, mapper: mapper)
      sut.resource_path = '/widgets'

      expect(client).to receive(:delete).with('/widgets/resource-1').and_return(
        @verified_response_double
      )
      sut.delete(resource)
    end

    it 'should tell the mapper to map the response' do
      resource = double(id: 'resource-1')
      client = double
      mapper = double
      sut = Trusona::Services::BaseService.new(
        client: client,
        mapper: mapper
      )

      allow(client).to receive(:delete).and_return(@verified_response_double)

      expect(mapper).to receive(:map).with(@verified_response_double, resource)
      sut.delete(resource)
    end

    context 'when the response cannot be verified' do
      it 'should raise an error' do
        resource = double(id: 'resource-1')
        client = double
        mapper = double(map: Object.new)
        sut = Trusona::Services::BaseService.new(
          client: client,
          mapper: mapper
        )

        allow(client).to receive(:delete).and_return(@unverified_response_double)
        expect { sut.delete(resource) }.to raise_error(Trusona::SigningError)
      end
    end

    context 'when the request fails' do
      before do
        @valid_resource = double(valid?: true, id: 1)
      end
      context 'for an unknown reason' do
        it 'should raise an error' do
          client = double(delete: @server_is_a_teapot_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(
              Trusona::RequestError,
              '[an error] a message - the description'
            )
          )
        end
      end
      context 'because it was unauthorized' do
        it 'should raise an error' do
          client = double(delete: @unauthorized_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(
              Trusona::UnauthorizedRequestError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because the request was malformed' do
        it 'should raise an error' do
          client = double(delete: @bad_request_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(
              Trusona::BadRequestError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because the resource could not be found' do
        it 'should raise an error' do
          client = double(delete: @not_found_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(
              Trusona::ResourceNotFoundError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because of a failed dependency' do
        it 'should raise an error' do
          client = double(delete: @failed_dependency_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(
              Trusona::FailedDependencyError,
              '[an error] a message - the description'
            )
          )
        end
      end

      context 'because of a server error' do
        it 'should raise an error' do
          client = double(delete: @internal_server_error_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end

      context 'because the server is unavailable' do
        it 'should raise an error' do
          client = double(delete: @server_busy_response)
          sut = Trusona::Services::BaseService.new(client: client)

          expect { sut.delete(@valid_resource) }.to(
            raise_error(Trusona::ApiError)
          )
        end
      end
    end
  end

end
# rubocop:enable Metrics/BlockLength
