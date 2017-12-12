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

  describe 'update' do

    let!(:user) { FactoryBot::create(:user_simon_ninon) }

    context 'invalid login' do

      let(:target_user) { FactoryBot::build(:user_mengying_li) }

      before { put :update, params: {login: target_user.login}, session: {user_id: user.id} }

      it 'should return a 404' do
        expect(response).to have_http_status(404)
        expect(response).to render_template('users/not_found')
      end

    end

    context 'unauthenticated user' do

      before { put :update, params: {login: user.login} }

      it 'should redirect to login page' do
        expect(response).to redirect_to(login_path)
      end

    end

    context 'authenticated user, different user' do

      let!(:target_user) { FactoryBot::create(:user_mengying_li) }

      before { put :update, params: {login: target_user.login}, session: {user_id: user.id} }

      it 'should redirect to root path (default permission denied behavior)' do
        expect(response).to redirect_to root_path
      end

    end

    context 'authenticated user, same user' do

      context 'success' do

        let(:edited_user) { FactoryBot::build(:user_mengying_li) }
        let(:new_project_1) { FactoryBot::build :project_cpp_redis }
        let(:new_project_2) { FactoryBot.build :project_tacopie }

        before do
          expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
            id:         user.github_ext_id,
            login:      edited_user.login,
            name:       edited_user.name,
            email:      edited_user.email,
            avatar_url: edited_user.avatar_url
          })

          expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return([{
            id:           new_project_1.ext_id,
            name:         new_project_1.name,
            description:  new_project_1.description,
            url:          new_project_1.repository_url,
            git_url:      new_project_1.git_url,
            homepage:     new_project_1.homepage_url
          },
          {
            id:           new_project_2.ext_id,
            name:         new_project_2.name,
            description:  new_project_2.description,
            url:          new_project_2.repository_url,
            git_url:      new_project_2.git_url,
            homepage:     new_project_2.homepage_url
          }])
        end

        it 'should redirect to user page with success flash' do
          put :update, params: {login: user.login}, session: {user_id: user.id}
          expect(response).to redirect_to user_path(login: user.login)
          expect(flash[:success]).to eq I18n.t("controllers.users_controller.update.success")
        end

        it 'should update the new user' do
          put :update, params: {login: user.login}, session: {user_id: user.id}

          expect(User.count).to eq 1

          # check user fields
          attrs = User.last.attributes.except("_id")
          expect(attrs).to eq({
            "github_ext_id" => user.github_ext_id,
            "login"         => edited_user.login,
            "name"          => edited_user.name,
            "email"         => edited_user.email,
            "avatar_url"    => edited_user.avatar_url
          })
        end

        it 'should create two new repos' do
          put :update, params: {login: user.login}, session: {user_id: user.id}

          expect(Project.count).to eq 2

          # check project fields
          attrs = Project.first.attributes.except("_id")
          expect(attrs).to eq({
            "slug"            => new_project_1.name, # name returned by github is used as both slug & name
            "name"            => new_project_1.name,
            "description"     => new_project_1.description,
            "repository_url"  => new_project_1.repository_url,
            "git_url"         => new_project_1.git_url,
            "homepage_url"    => new_project_1.homepage_url,
            "ext_id"          => new_project_1.ext_id,
            "ext_source"      => Platform::GITHUB,
            "owner_id"        => User.first.id
          })

          # check project fields
          attrs = Project.last.attributes.except("_id")
          expect(attrs).to eq({
            "slug"            => new_project_2.name, # name returned by github is used as both slug & name
            "name"            => new_project_2.name,
            "description"     => new_project_2.description,
            "repository_url"  => new_project_2.repository_url,
            "git_url"         => new_project_2.git_url,
            "homepage_url"    => new_project_2.homepage_url,
            "ext_id"          => new_project_2.ext_id,
            "ext_source"      => Platform::GITHUB,
            "owner_id"        => User.first.id
          })
        end

      end

      context 'failure' do

        before { expect_any_instance_of(Octokit::Client).to receive(:user).and_raise("fail") }

        it 'should redirect to user page with an error flash' do
          put :update, params: {login: user.login}, session: {user_id: user.id}
          expect(response).to redirect_to user_path(login: user.login)
          expect(flash[:error]).to eq I18n.t("controllers.users_controller.update.error")
        end

        it 'should create a new user' do
          put :update, params: {login: user.login}, session: {user_id: user.id}

          expect(User.count).to eq 1
        end

        it 'should create new repos' do
          put :update, params: {login: user.login}, session: {user_id: user.id}

          expect(Project.count).to eq 0
        end

      end

    end

  end

end
