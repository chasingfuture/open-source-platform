require 'rails_helper'

RSpec.describe GithubSynchronizer do

  # just global test here as sync_user is a wrapper of both sync_profile and sync_repos
  describe 'synchronize_user' do

    let(:new_user) { FactoryBot.build :user_simon_ninon }
    let(:new_project_1) { FactoryBot::build :project_cpp_redis }
    let(:new_project_2) { FactoryBot.build :project_tacopie }

    # mock octokit
    before do
      expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
        id:         new_user.github_ext_id,
        login:      new_user.login,
        name:       new_user.name,
        email:      new_user.email,
        avatar_url: new_user.avatar_url
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

    it 'should create a new user' do
      GithubSynchronizer::synchronize_user 'access_token'
      expect(User.count).to eq 1

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

    it 'should create two new repos' do
      GithubSynchronizer::synchronize_user 'access_token'
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

  describe 'synchronize_profile' do

    let!(:existing_user) { FactoryBot.create :user_simon_ninon }

    context 'when it fails to fetch profile' do

      # mock octokit
      before { expect_any_instance_of(Octokit::Client).to receive(:user).and_raise("fail") }

      it 'should raise an error and not create a new user' do
        expect{ GithubSynchronizer::synchronize_profile 'access_token' }.to raise_error "fail"
        expect(User.count).to eq 1
      end

    end

    context 'when it fetches invalid profile information' do

      # mock octokit
      before { expect_any_instance_of(Octokit::Client).to receive(:user).and_return({}) }

      it 'should raise an error and not create a new user' do
        expect{ GithubSynchronizer::synchronize_profile 'access_token' }.to raise_error Mongoid::Errors::Validations
        expect(User.count).to eq 1
      end

    end

    context 'when the user account does not exist yet' do

      let(:new_user) { FactoryBot.build :user_mengying_li }

      # mock octokit
      before do
        expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
          id:       new_user.github_ext_id,
          login:      new_user.login,
          name:       new_user.name,
          email:      new_user.email,
          avatar_url: new_user.avatar_url
        })
      end

      it 'should create a new account' do
        GithubSynchronizer::synchronize_profile 'access_token'
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
          expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
            id:         existing_user.github_ext_id,
            login:      existing_user.login,
            name:       existing_user.name,
            email:      existing_user.email,
            avatar_url: existing_user.avatar_url
          })
        end

        it 'should update the user information' do
          GithubSynchronizer::synchronize_profile 'access_token'
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
          expect_any_instance_of(Octokit::Client).to receive(:user).and_return({
            id:         existing_user.github_ext_id,
            login:      edited_user.login,
            name:       edited_user.name,
            email:      edited_user.email,
            avatar_url: edited_user.avatar_url
          })
        end

        it 'should update the user information' do
          GithubSynchronizer::synchronize_profile 'access_token'
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

  describe 'synchronize_repositories' do

    let!(:user) { FactoryBot.create :user_simon_ninon }
    let!(:existing_project) { FactoryBot::create :project_cpp_redis }

    context 'when it fails to fetch repositories' do

      # mock octokit
      before { expect_any_instance_of(Octokit::Client).to receive(:repositories).and_raise("fail") }

      it 'should raise an error and not create a new project' do
        expect{ GithubSynchronizer::synchronize_repositories 'access_token', user }.to raise_error "fail"
        expect(Project.count).to eq 1
      end

    end

    context 'when it fetches invalid repos information' do

      # mock octokit
      before { expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return([{}]) }

      it 'should raise an error and not create a new project' do
        expect{ GithubSynchronizer::synchronize_repositories 'access_token', user }.to raise_error Mongoid::Errors::Validations
        expect(Project.count).to eq 1
      end

    end

    context 'when the project does not exist yet' do

      let(:new_project) { FactoryBot.build :project_tacopie }

      # mock octokit
      before do
        expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return([{
          id:           existing_project.ext_id,
          name:         existing_project.name,
          description:  existing_project.description,
          url:          existing_project.repository_url,
          git_url:      existing_project.git_url,
          homepage:     existing_project.homepage_url
        },
        {
          id:           new_project.ext_id,
          name:         new_project.name,
          description:  new_project.description,
          url:          new_project.repository_url,
          git_url:      new_project.git_url,
          homepage:     new_project.homepage_url
        }])
      end

      it 'should create a new project' do
        GithubSynchronizer::synchronize_repositories 'access_token', user
        expect(Project.count).to eq 2

        # check project fields
        attrs = Project.last.attributes.except("_id")
        expect(attrs).to eq({
          "slug"            => new_project.slug,
          "name"            => new_project.name,
          "description"     => new_project.description,
          "repository_url"  => new_project.repository_url,
          "git_url"         => new_project.git_url,
          "homepage_url"    => new_project.homepage_url,
          "ext_id"          => new_project.ext_id,
          "ext_source"      => Platform::GITHUB,
          "owner_id"        => user.id
        })
      end

    end

    context 'when the project exists' do

      context 'with same info' do

        # mock octokit
        before do
          expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return([{
            id:           existing_project.ext_id,
            name:         existing_project.name,
            description:  existing_project.description,
            url:          existing_project.repository_url,
            git_url:      existing_project.git_url,
            homepage:     existing_project.homepage_url
          }])
        end

        it 'should update the project information' do
          GithubSynchronizer::synchronize_repositories 'access_token', user
          expect(Project.count).to eq 1

          # check user fields
          attrs = Project.first.attributes.except("_id")
          expect(attrs).to eq({
            "slug"            => existing_project.name, # name returned by github is used as both slug & name
            "name"            => existing_project.name,
            "description"     => existing_project.description,
            "repository_url"  => existing_project.repository_url,
            "git_url"         => existing_project.git_url,
            "homepage_url"    => existing_project.homepage_url,
            "ext_id"          => existing_project.ext_id,
            "ext_source"      => Platform::GITHUB,
            "owner_id"        => user.id
          })
        end

      end

      context 'with updated info' do

        let(:new_project) { FactoryBot.build :project_tacopie }

        # mock octokit
        before do
          expect_any_instance_of(Octokit::Client).to receive(:repositories).and_return([{
            id:           existing_project.ext_id,
            name:         new_project.name,
            description:  new_project.description,
            url:          new_project.repository_url,
            git_url:      new_project.git_url,
            homepage:     new_project.homepage_url
          }])
        end

        it 'should update the project information' do
          GithubSynchronizer::synchronize_repositories 'access_token', user
          expect(Project.count).to eq 1

          # check user fields
          attrs = Project.first.attributes.except("_id")
          expect(attrs).to eq({
            "slug"            => new_project.name, # name returned by github is used as both slug & name
            "name"            => new_project.name,
            "description"     => new_project.description,
            "repository_url"  => new_project.repository_url,
            "git_url"         => new_project.git_url,
            "homepage_url"    => new_project.homepage_url,
            "ext_id"          => existing_project.ext_id,
            "ext_source"      => Platform::GITHUB,
            "owner_id"        => user.id
          })
        end

      end

    end

  end

end
