require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe 'show' do

    context 'valid slug' do

      let(:project) { FactoryBot::create(:project_cpp_redis) }

      before { get :show, params: {slug: project.slug} }

      it 'should work' do
        expect(response).to have_http_status(200)
        expect(response).to render_template('projects/show')
      end

    end

    context 'invalid slug' do

      let(:project) { FactoryBot::build(:project_cpp_redis) }

      before { get :show, params: {slug: project.slug} }

      it 'should return a 404' do
        expect(response).to have_http_status(404)
        expect(response).to render_template('projects/not_found')
      end

    end

  end

end
