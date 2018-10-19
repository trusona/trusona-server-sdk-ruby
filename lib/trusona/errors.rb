# frozen_string_literal: true

module Trusona
  ##
  # A generic error for when things go wrong, but we're not sure why
  class TrusonaError < StandardError; end

  ##
  # An error that occurs when the configuration is incorrect or invalid
  class ConfigurationError < TrusonaError; end

  ##
  # An error resulting from a resource that is invalid due to missing
  # required fields
  class InvalidResourceError < TrusonaError; end

  ##
  # An error used to indicate a failure in HMAC signing
  class SigningError < TrusonaError; end

  ##
  # An error reserved for problems communicating with the Trusona REST API
  class RequestError < TrusonaError; end

  ##
  # The result of attempting to access the Trusona REST API with invalid
  # or missing SDK Keys (Token and Secret)
  class UnauthorizedRequestError < RequestError; end

  ##
  # An error for resulting from 50x errors from the Trusona REST API
  class ApiError < RequestError; end

  ##
  # An error resulting from 404 errors from the Trusona REST API
  class ResourceNotFoundError < RequestError; end

  ##
  # An error resulting from 400 errors from the Trusona REST API
  class BadRequestError < RequestError; end

  ##
  # An error resulting from 422 errors from the Trusona REST API
  class UnprocessableEntityError < RequestError; end

  ##
  # An error resulting from 424 errors from the Trusona REST API
  class FailedDependencyError < RequestError; end

  ##
  # An error resulting from trying to find a record without a valid
  # identifier. Prempts a `Trusona::ResourceNotFoundError` error by
  # not making a network request with an invalid identifier.
  class InvalidRecordIdentifier < TrusonaError; end
end
