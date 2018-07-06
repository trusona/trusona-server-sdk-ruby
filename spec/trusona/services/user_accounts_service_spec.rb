# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Trusona::Services::UserAccountsService do
  describe 'creating a new User Accounts Service' do
    it 'accepts a custom client' do
      Trusona::Services::UserAccountsService.new(client: double)
    end
    it 'accepts a custom mapper' do
      Trusona::Services::UserAccountsService.new(mapper: double)
    end
  end
end
