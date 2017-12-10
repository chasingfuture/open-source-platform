require 'rails_helper'

RSpec.describe Authentication do

  class TestingClass
    include Authentication

    def current_user=(user)
      @current_user = user
    end

    def session
      @session ||= {}
    end

    def redirect_to(uri)
    end

    def login_path
      'login_path'
    end

  end

  let(:user) { FactoryBot.create :user_simon_ninon }
  let(:testing_class) { TestingClass.new }

  describe 'current_user' do

    context 'when current_user is set' do

      it 'should return right away' do
        # force set a specific user
        testing_class.current_user = user

        # make sure authenticate is not called and user is returned right away
        expect(testing_class).not_to receive(:authenticate_with_session)
        # test that the valid user is returned
        expect(testing_class.current_user).to eq user
      end

    end

    context 'when current_user is not set but user is authenticated (has session)' do

      it 'should authenticate the user based on the session and return it' do
        # set the session
        testing_class.session[:user_id] = user.id

        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # test that the valid user is returned
        expect(testing_class.current_user).to eq user
      end

    end

    context 'when current_user is not set and user is not authenticated (has no session)' do

      it 'should fail to authenticate the user based on the session and return nil' do
        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # test that the valid user is returned
        expect(testing_class.current_user).to eq nil
      end

    end

  end

  describe 'authenticated?' do

    context 'when current_user is set' do

      it 'should return true' do
        # force set a specific user
        testing_class.current_user = user

        # make sure authenticate is not called and user is returned right away
        expect(testing_class).not_to receive(:authenticate_with_session)
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should be authenticated
        expect(testing_class.authenticated?).to be_truthy
      end

    end

    context 'when current_user is not set but user is authenticated (has session)' do

      it 'should return true after authenticating the user based on its session' do
        # set the session
        testing_class.session[:user_id] = user.id

        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should be authenticated
        expect(testing_class.authenticated?).to be_truthy
      end

    end

    context 'when current_user is not set and user is not authenticated (has no session)' do

      it 'should return false after failing to authenticate the user based on its session' do
        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should not be authenticated
        expect(testing_class.authenticated?).to be_falsey
      end

    end

  end

  describe 'user_signed_in?' do

    context 'when current_user is set' do

      it 'should return true' do
        # force set a specific user
        testing_class.current_user = user

        # make sure authenticate is not called and user is returned right away
        expect(testing_class).not_to receive(:authenticate_with_session)
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should be authenticated
        expect(testing_class.user_signed_in?).to be_truthy
      end

    end

    context 'when current_user is not set but user is authenticated (has session)' do

      it 'should return true after authenticating the user based on its session' do
        # set the session
        testing_class.session[:user_id] = user.id

        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should be authenticated
        expect(testing_class.user_signed_in?).to be_truthy
      end

    end

    context 'when current_user is not set and user is not authenticated (has no session)' do

      it 'should return false after failing to authenticate the user based on its session' do
        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it calls current_user function
        expect(testing_class).to receive(:current_user).and_call_original
        # should not be authenticated
        expect(testing_class.user_signed_in?).to be_falsey
      end

    end

  end

  describe 'authenticate' do
  end

  describe 'authenticate!' do

    context 'when current_user is set' do

      it 'should not redirect' do
        # force set a specific user
        testing_class.current_user = user

        # make sure authenticate is not called and user is returned right away
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it does not trigger redirection
        expect(testing_class).not_to receive(:redirect_to)

        testing_class.authenticate!
      end

    end

    context 'when current_user is not set but user is authenticated (has session)' do

      it 'should not redirect after authenticating the user based on its session' do
        # set the session
        testing_class.session[:user_id] = user.id

        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it does not trigger redirection
        expect(testing_class).not_to receive(:redirect_to)

        testing_class.authenticate!
      end

    end

    context 'when current_user is not set and user is not authenticated (has no session)' do

      it 'should redirect after failing to authenticate the user based on its session' do
        # make sure authenticate is called
        expect(testing_class).to receive(:authenticate_with_session).and_call_original
        # make sure it triggers redirection
        expect(testing_class).to receive(:redirect_to).with(testing_class.login_path)

        testing_class.authenticate!
      end

    end

  end

end
