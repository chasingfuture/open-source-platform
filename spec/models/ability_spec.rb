require 'rails_helper'

RSpec.describe Ability do

  describe 'Project' do

    let!(:project) { FactoryBot::create :project_cpp_redis }
    let!(:owner) { project.owner }
    let!(:other_user) { FactoryBot::create :user_mengying_li }

    describe 'read' do

      context 'unauthenticated user' do

        let!(:ability) { Ability.new(User.new) }

        it 'should be authorized' do
          expect(ability.can? :read, project).to be_truthy
        end

      end

      context 'authenticated user, not owner' do

        let!(:ability) { Ability.new(other_user) }

        it 'should be authorized' do
          expect(ability.can? :read, project).to be_truthy
        end

      end

      context 'authenticated user, owner' do

        let!(:ability) { Ability.new(owner) }

        it 'should be authorized' do
          expect(ability.can? :read, project).to be_truthy
        end

      end

    end

    describe 'update' do

      context 'unauthenticated user' do

        let!(:ability) { Ability.new(User.new) }

        it 'should not be authorized' do
          expect(ability.can? :update, project).to be_falsey
        end

      end

      context 'authenticated user, not owner' do

        let!(:ability) { Ability.new(other_user) }

        it 'should not be authorized' do
          expect(ability.can? :update, project).to be_falsey
        end

      end

      context 'authenticated user, owner' do

        let!(:ability) { Ability.new(owner) }

        it 'should be authorized' do
          expect(ability.can? :update, project).to be_truthy
        end

      end

    end

  end

  describe 'User' do

    let!(:target_user) { FactoryBot::create :user_simon_ninon }
    let!(:observer) { FactoryBot::create :user_mengying_li }

    describe 'read' do

      context 'unauthenticated user' do

        let!(:ability) { Ability.new(User.new) }

        it 'should be authorized' do
          expect(ability.can? :read, target_user).to be_truthy
        end

      end

      context 'authenticated user, different user' do

        let!(:ability) { Ability.new(observer) }

        it 'should be authorized' do
          expect(ability.can? :read, target_user).to be_truthy
        end

      end

      context 'authenticated user, same user' do

        let!(:ability) { Ability.new(target_user) }

        it 'should be authorized' do
          expect(ability.can? :read, target_user).to be_truthy
        end

      end

    end

    describe 'update' do

      context 'unauthenticated user' do

        let!(:ability) { Ability.new(User.new) }

        it 'should not be authorized' do
          expect(ability.can? :update, target_user).to be_falsey
        end

      end

      context 'authenticated user, different user' do

        let!(:ability) { Ability.new(observer) }

        it 'should not be authorized' do
          expect(ability.can? :update, target_user).to be_falsey
        end

      end

      context 'authenticated user, same user' do

        let!(:ability) { Ability.new(target_user) }

        it 'should be authorized' do
          expect(ability.can? :update, target_user).to be_truthy
        end

      end

    end

  end

end
