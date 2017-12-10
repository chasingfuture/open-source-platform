require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'show' do

    context 'valid login' do

      let(:user) { FactoryBot::create(:user_simon_ninon) }

      before { get :show, params: {login: user.login} }

      it 'should work' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('users/show')
      end

    end

    context 'invalid login' do

      let(:user) { FactoryBot::build(:user_simon_ninon) }

      before { get :show, params: {login: user.login} }

      it 'should return a 404' do
        expect(response).to have_http_status(404)
        expect(response).to render_template('users/not_found')
      end

    end

  end

end
