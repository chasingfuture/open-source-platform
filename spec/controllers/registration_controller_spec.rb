require 'rails_helper'

RSpec.describe RegistrationController, type: :controller do

  let!(:user) { FactoryBot.create :user_simon_ninon }

  describe 'login' do

    context 'when the user is already authenticated' do

      it 'should redirect to the home page' do
        get :login, session: { user_id: user.id }
        expect(response).to redirect_to root_path
      end

    end

    context 'when the user is not authenticated' do

      it 'should redirect to the github oauth login page' do
        get :login
        expect(response).to redirect_to Github::oauth_login_url
      end

    end

  end

  describe 'login_via_github' do

    context 'when the user is already authenticated' do

      it 'should redirect to the home page' do
        get :login_via_github, session: { user_id: user.id }
        expect(response).to redirect_to root_path
      end

    end

    context 'when it fails to exchange code' do

      let(:user) { FactoryBot.build :user_simon_ninon }

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_raise("fail")
      end

      it 'should redirect ot home page' do
        get :login_via_github, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.registration_controller.login_via_github.error")
      end

      it 'should not create a new account' do
        get :login_via_github, params: { code: '1234' }
        expect(User.count).to eq 0
      end

    end

    context 'when it fails to fetch profile' do

      let(:user) { FactoryBot.build :user_simon_ninon }

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
        expect_any_instance_of(Octokit::Client).to receive(:user).and_raise("fail")
      end

      it 'should redirect ot home page' do
        get :login_via_github, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.registration_controller.login_via_github.error")
      end

      it 'should not create a new account' do
        get :login_via_github, params: { code: '1234' }
        expect(User.count).to eq 0
      end

    end

    context 'when it fetches invalid profile information' do

      let(:user) { FactoryBot.build :user_simon_ninon }

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
        expect_any_instance_of(Octokit::Client).to receive(:user).and_return({})
      end

      it 'should redirect ot home page' do
        get :login_via_github, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.registration_controller.login_via_github.error")
      end

      it 'should not create a new account' do
        get :login_via_github, params: { code: '1234' }
        expect(User.count).to eq 0
      end

    end

    context 'when the user is not authenticated' do

      context 'when the user account does not exist yet' do

        let(:new_user) { FactoryBot.build :user_mengying_li }

        # mock octokit
        before do
          expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
          expect_any_instance_of(Octokit::Client).to receive(:user).and_return({ id: new_user.github_ext_id, login: new_user.login, name: new_user.name, email: new_user.email, avatar_url: new_user.avatar_url })
        end

        it 'should redirect ot home page' do
          get :login_via_github, params: { code: '1234' }
          expect(response).to redirect_to root_path
          expect(flash[:success]).to eq I18n.t("controllers.registration_controller.login_via_github.success")
        end

        it 'should create a new account' do
          get :login_via_github, params: { code: '1234' }
          expect(User.count).to eq 2

          # check user fields
          attrs = User.last.attributes.slice(:github_ext_id, :login, :name, :email, :avatar_url)
          expect(attrs).to eq({ "github_ext_id" => new_user.github_ext_id, "login" => new_user.login, "name" => new_user.name, "email" => new_user.email, "avatar_url" => new_user.avatar_url })
        end

      end

      context 'when the user account exists' do

        context 'with same info' do

          # mock octokit
          before do
            expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
            expect_any_instance_of(Octokit::Client).to receive(:user).and_return({ id: user.github_ext_id, login: user.login, name: user.name, email: user.email, avatar_url: user.avatar_url })
          end

          it 'should redirect ot home page' do
            get :login_via_github, params: { code: '1234' }
            expect(response).to redirect_to root_path
            expect(flash[:success]).to eq I18n.t("controllers.registration_controller.login_via_github.success")
          end

          it 'should update the user information' do
            get :login_via_github, params: { code: '1234' }
            expect(User.count).to eq 1

            # check user fields
            attrs = User.first.attributes.slice(:github_ext_id, :login, :name, :email, :avatar_url)
            expect(attrs).to eq({ "github_ext_id" => user.github_ext_id, "login" => user.login, "name" => user.name, "email" => user.email, "avatar_url" => user.avatar_url })
          end

        end

        context 'with updated info' do

          let(:edited_user) { FactoryBot.build :user_mengying_li }

          # mock octokit
          before do
            expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
            expect_any_instance_of(Octokit::Client).to receive(:user).and_return({ id: user.github_ext_id, login: edited_user.login, name: edited_user.name, email: edited_user.email, avatar_url: edited_user.avatar_url })
          end

          it 'should redirect ot home page' do
            get :login_via_github, params: { code: '1234' }
            expect(response).to redirect_to root_path
            expect(flash[:success]).to eq I18n.t("controllers.registration_controller.login_via_github.success")
          end

          it 'should update the user information' do
            get :login_via_github, params: { code: '1234' }
            expect(User.count).to eq 1

            # check user fields
            attrs = User.first.attributes.slice(:github_ext_id, :login, :name, :email, :avatar_url)
            expect(attrs).to eq({ "github_ext_id" => user.github_ext_id, "login" => edited_user.login, "name" => edited_user.name, "email" => edited_user.email, "avatar_url" => edited_user.avatar_url })
          end

        end

      end

    end

  end

end
