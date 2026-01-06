require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:user_account) { create(:account) }

  before do
    create(:account_user, user: user, account: user_account)
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns the current user\'s accounts to @accounts' do
      other_account = create(:account)
      create(:account_user, user: user, account: other_account)
      
      get :index
      expect(assigns(:accounts)).to include(user_account)
      expect(assigns(:accounts)).to include(other_account)
      expect(assigns(:accounts)).not_to include(account)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'initializes a new account' do
      get :new
      expect(assigns(:account)).to be_a_new(Account)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          account: {
            name: 'Test Account',
            description: 'Test Description'
          }
        }
      end

      it 'creates a new account' do
        expect {
          post :create, params: valid_attributes
        }.to change(Account, :count).by(1)
      end

      it 'creates an account_user association' do
        expect {
          post :create, params: valid_attributes
        }.to change(AccountUser, :count).by(1)
      end

      it 'associates the account with the current user' do
        post :create, params: valid_attributes
        created_account = Account.last
        expect(created_account.users).to include(user)
      end

      it 'redirects to accounts index' do
        post :create, params: valid_attributes
        expect(response).to redirect_to(accounts_path)
      end

      it 'sets a success flash message' do
        post :create, params: valid_attributes
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          account: {
            name: nil,
            description: 'Test Description'
          }
        }
      end

      it 'does not create a new account' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Account, :count)
      end

      it 'does not create an account_user association' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(AccountUser, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_attributes
        expect(response).to render_template(:new)
      end

      it 'sets an error flash message' do
        post :create, params: invalid_attributes
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe 'POST #switch' do
    context 'when user owns the account' do
      it 'redirects to console dashboard' do
        post :switch, params: { id: user_account.id }
        expect(response).to redirect_to(account_console_dashboard_path(account_id: user_account.id))
      end

      it 'sets a success flash message' do
        post :switch, params: { id: user_account.id }
        expect(flash[:notice]).to be_present
      end
    end

    context 'when user does not own the account' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          post :switch, params: { id: account.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'authorization' do
    context 'when user is not signed in' do
      before do
        sign_out(user)
      end

      it 'redirects to sign in page for index' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign in page for new' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign in page for create' do
        post :create, params: { account: { name: 'Test' } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to sign in page for switch' do
        post :switch, params: { id: user_account.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

