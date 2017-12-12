require 'rails_helper'

RSpec.describe LinkHelper, type: :helper do

  describe 'compose_user_path' do

    let(:user) { FactoryBot::create :user_simon_ninon }

    it 'should build a valid path' do
      expect(compose_user_path user).to eq "/users/#{ user.login }"
    end

  end

  describe 'compose_project_path' do

    let(:project) { FactoryBot::create :project_cpp_redis }

    it 'should build a valid path' do
      expect(compose_project_path project.owner, project).to eq "/users/#{ project.owner.login }/#{ project.ext_source }/#{ project.slug }"
    end

  end

end
