require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do

    describe 'projects' do

      # User 1 project
      let!(:simon_ninon) { FactoryBot::create :user_simon_ninon }
      let!(:project_1_simon_ninon) { FactoryBot::create :project_cpp_redis }
      let!(:project_2_simon_ninon) { FactoryBot::create :project_tacopie }

      # User 2 project
      let!(:mengying_li) { FactoryBot::create :user_mengying_li }
      let!(:project_mengying_li) { FactoryBot::create :project_cse_110 }

      it 'should list the appropriate projects' do
        expect(simon_ninon.projects).to eq [ project_1_simon_ninon, project_2_simon_ninon ]
        expect(mengying_li.projects).to eq [ project_mengying_li ]
      end

    end

  end

  describe 'validations' do

    let(:user) { FactoryBot::build :user_simon_ninon }

    describe 'default user' do

      it 'should be valid' do
        expect(user.valid?).to be_truthy
      end

    end

    describe 'name' do

      describe 'nil' do

        before { user.name = nil }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

      describe 'empty' do

        before { user.name = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

      describe 'blank' do

        before { user.name = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

    end

    describe 'email' do

      describe 'nil' do

        before { user.email = nil }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

      describe 'empty' do

        before { user.email = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

      describe 'blank' do

        before { user.email = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_truthy
        end

      end

    end

    describe 'github_ext_id' do

      describe 'nil' do

        before { user.github_ext_id = nil }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { user.github_ext_id = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { user.github_ext_id = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'not unique' do

        before { FactoryBot::create :user_simon_ninon, github_ext_id: user.github_ext_id }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

    end

    describe 'login' do

      describe 'nil' do

        before { user.login = nil }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { user.login = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { user.login = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'not unique' do

        before { FactoryBot::create :user_simon_ninon, login: user.login }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

    end

  end

end
