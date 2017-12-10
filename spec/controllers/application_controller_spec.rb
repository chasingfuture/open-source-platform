require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe 'authentication' do

    it 'should include the authentication concern' do
      expect(ApplicationController.included_modules.include? Authentication).to be_truthy
    end

  end

end
