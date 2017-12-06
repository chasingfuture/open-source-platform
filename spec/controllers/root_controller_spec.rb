require 'rails_helper'

RSpec.describe RootController, type: :controller do

  describe 'RootController#index' do

    before { get :index }

    it 'should work' do
      expect(response).to have_http_status(200)
      expect(response).to render_template('root/index')
    end

  end

end
