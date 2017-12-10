require 'rails_helper'

RSpec.describe User, type: :model do

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
          expect(user.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { user.name = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { user.name = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

    end

    describe 'email' do

      describe 'nil' do

        before { user.email = nil }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { user.email = "" }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { user.email = "   " }

        it 'should not be valid' do
          expect(user.valid?).to be_falsey
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
