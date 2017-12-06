require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'validations' do

    let(:project) { FactoryBot::build :project_cpp_redis }

    describe 'default project' do

      it 'should be valid' do
        expect(project.valid?).to be_truthy
      end

    end

    describe 'name' do

      describe 'nil' do

        before { project.name = nil }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { project.name = "" }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { project.name = "   " }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

    end

    describe 'repository_url' do

      describe 'nil' do

        before { project.repository_url = nil }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { project.repository_url = "" }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { project.repository_url = "   " }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

    end

    describe 'git_url' do

      describe 'nil' do

        before { project.git_url = nil }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { project.git_url = "" }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { project.git_url = "   " }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

    end

    describe 'slug' do

      describe 'nil' do

        before { project.slug = nil }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'empty' do

        before { project.slug = "" }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'blank' do

        before { project.slug = "   " }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

      describe 'not unique' do

        before { FactoryBot::create :project_tacopie, slug: project.slug }

        it 'should not be valid' do
          expect(project.valid?).to be_falsey
        end

      end

    end

  end

end
