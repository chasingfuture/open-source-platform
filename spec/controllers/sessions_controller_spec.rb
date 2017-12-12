require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let!(:existing_user) { FactoryBot.create :user_simon_ninon }

  describe 'login' do

    context 'when the user is already authenticated' do

      it 'should redirect to the home page' do
        get :new, session: { user_id: existing_user.id }
        expect(response).to redirect_to root_path
      end

    end

    context 'when the user is not authenticated' do

      it 'should redirect to the github oauth login page' do
        get :new
        expect(response).to redirect_to GithubAPI::oauth_login_url
      end

    end

  end

  describe 'create' do

    context 'when the user is already authenticated' do

      it 'should redirect to the home page' do
        get :create, session: { user_id: existing_user.id }
        expect(response).to redirect_to root_path
      end

    end

    context 'when it fails to exchange code' do

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_raise("fail")
      end

      it 'should redirect ot home page' do
        get :create, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.sessions_controller.create.error")
      end

      it 'should not create a new account' do
        get :create, params: { code: '1234' }
        expect(User.count).to eq 1
      end

    end

    context 'when it fails to fetch profile' do

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
        expect_any_instance_of(Octokit::Client).to receive(:user).and_raise("fail")
      end

      it 'should redirect ot home page' do
        get :create, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.sessions_controller.create.error")
      end

      it 'should not create a new account' do
        get :create, params: { code: '1234' }
        expect(User.count).to eq 1
      end

    end

    context 'when it fetches invalid profile information' do

      # mock octokit
      before do
        expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
        expect_any_instance_of(Octokit::Client).to receive(:user).and_return({})
      end

      it 'should redirect ot home page' do
        get :create, params: { code: '1234' }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq I18n.t("controllers.sessions_controller.create.error")
      end

      it 'should not create a new account' do
        get :create, params: { code: '1234' }
        expect(User.count).to eq 1
      end

    end

    context 'when the user is not authenticated' do

      context 'when the user account does not exist yet' do

        let(:new_user) { FactoryBot.build :user_mengying_li }

        # mock octokit
        before do
          expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
          expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
            id:         new_user.github_ext_id,
            login:      new_user.login,
            name:       new_user.name,
            email:      new_user.email,
            avatar_url: new_user.avatar_url
          })
        end

        it 'should redirect ot home page' do
          get :create, params: { code: '1234' }
          expect(response).to redirect_to root_path
          expect(flash[:success]).to eq I18n.t("controllers.sessions_controller.create.success")
        end

        it 'should create a new account' do
          get :create, params: { code: '1234' }
          expect(User.count).to eq 2

          # check user fields
          attrs = User.last.attributes.except("_id")
          expect(attrs).to eq({
            "github_ext_id" => new_user.github_ext_id,
            "login"         => new_user.login,
            "name"          => new_user.name,
            "email"         => new_user.email,
            "avatar_url"    => new_user.avatar_url
          })
        end

      end

      context 'when the user account exists' do

        context 'with same info' do

          # mock octokit
          before do
            expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
            expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
              id:         existing_user.github_ext_id,
              login:      existing_user.login,
              name:       existing_user.name,
              email:      existing_user.email,
              avatar_url: existing_user.avatar_url
            })
          end

          it 'should redirect ot home page' do
            get :create, params: { code: '1234' }
            expect(response).to redirect_to root_path
            expect(flash[:success]).to eq I18n.t("controllers.sessions_controller.create.success")
          end

          it 'should update the user information' do
            get :create, params: { code: '1234' }
            expect(User.count).to eq 1

            # check user fields
            attrs = User.first.attributes.except("_id")
            expect(attrs).to eq({
              "github_ext_id" => existing_user.github_ext_id,
              "login"         => existing_user.login,
              "name"          => existing_user.name,
              "email"         => existing_user.email,
              "avatar_url"    => existing_user.avatar_url
            })
          end

        end

        context 'with updated info' do

          let(:edited_user) { FactoryBot.build :user_mengying_li }

          # mock octokit
          before do
            expect(Octokit).to receive(:exchange_code_for_token).and_return({access_token: "access_token"})
            expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
              id:         existing_user.github_ext_id,
              login:      edited_user.login,
              name:       edited_user.name,
              email:      edited_user.email,
              avatar_url: edited_user.avatar_url
            })
          end

          it 'should redirect ot home page' do
            get :create, params: { code: '1234' }
            expect(response).to redirect_to root_path
            expect(flash[:success]).to eq I18n.t("controllers.sessions_controller.create.success")
          end

          it 'should update the user information' do
            get :create, params: { code: '1234' }
            expect(User.count).to eq 1

            # check user fields
            attrs = User.first.attributes.except("_id")
            expect(attrs).to eq({
              "github_ext_id" => existing_user.github_ext_id,
              "login"         => edited_user.login,
              "name"          => edited_user.name,
              "email"         => edited_user.email,
              "avatar_url"    => edited_user.avatar_url
            })
          end

        end

      end

    end

  end

  describe 'destroy' do

    context 'when the user is already authenticated' do

      it 'should redirect to the home page' do
        get :new, session: { user_id: existing_user.id }
        expect(session[:user_id]).to eq existing_user.id

        delete :destroy
        expect(response).to redirect_to root_path
        expect(session[:user_id]).to eq nil
      end

    end

    context 'when the user is not authenticated' do

      it 'should redirect to the login page' do
        delete :destroy
        expect(response).to redirect_to login_path
      end

    end

  end

end
