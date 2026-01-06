require 'rails_helper'

RSpec.describe Webapp::TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:category) { create(:category, account: account) }

  before do
    create(:account_user, user: user, account: account)
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { account_id: account.id }
      expect(response).to be_successful
    end

    it 'assigns @transactions' do
      transaction = create(:transaction, account: account, category: category)
      get :index, params: { account_id: account.id }
      expect(assigns(:transactions)).to include(transaction)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { account_id: account.id }
      expect(response).to be_successful
    end

    it 'assigns a new transaction to @transaction' do
      get :new, params: { account_id: account.id }
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      transaction = create(:transaction, account: account, category: category)
      get :edit, params: { account_id: account.id, id: transaction.id }
      expect(response).to be_successful
    end

    it 'assigns the requested transaction to @transaction' do
      transaction = create(:transaction, account: account, category: category)
      get :edit, params: { account_id: account.id, id: transaction.id }
      expect(assigns(:transaction)).to eq(transaction)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Transaction' do
        expect {
          post :create, params: { account_id: account.id, transaction: attributes_for(:transaction).merge(category_id: category.id) }
          transaction = assigns(:transaction)
          puts transaction.errors.full_messages unless transaction.persisted? # Add this line to print validation errors
        }.to change(Transaction, :count).by(1)
      end

      it 'redirects to the new transaction path' do
        post :create, params: { account_id: account.id, transaction: attributes_for(:transaction).merge(category_id: category.id) }
        expect(response).to redirect_to(new_account_webapp_transaction_path(account_id: account.id))
      end
    end

    context 'with invalid params' do
      it 'does not create a new Transaction' do
        expect {
          post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, description: nil).merge(category_id: category.id) }
        }.to change(Transaction, :count).by(0)
      end

      it 'renders the new template' do
        post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, description: nil).merge(category_id: category.id) }
        expect(response).to render_template(:new)
      end

      it 'renders the new template' do
        post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, description: nil) }
        expect(response).to render_template(:new)
      end
    end

    context '#set_category' do
      it 'creates a new income transaction with correct category type' do
        income_category = create(:category, account: account, category_type: 'incomes')
        expect {
          post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, transaction_type: 'income')
                                                 .merge(category_id: income_category.id) }
        }.to change(Transaction.incomes, :count).by(1)
      end

      it 'creates a new income transaction with correct category type' do
        expense_category = create(:category, account: account, category_type: 'expenses')
        expect {
          post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, transaction_type: 'expense')
                                                 .merge(category_id: expense_category.id) }
        }.to change(Transaction.expenses, :count).by(1)
      end

      it 'does not create a new transaction with correct category type' do
        expect {
          post :create, params: { account_id: account.id, transaction: attributes_for(:transaction, transaction_type: 'expense')
                                                 .merge(category_id: create(:category, account: account, category_type: 'invalid').id) }
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested transaction' do
        transaction = create(:transaction, account: account, category: category)
        patch :update, params: { account_id: account.id, id: transaction.id, transaction: { description: 'Updated' } }
        transaction.reload
        expect(transaction.description).to eq('Updated')
      end

      it 'redirects to the transactions path' do
        transaction = create(:transaction, account: account, category: category)
        patch :update, params: { account_id: account.id, id: transaction.id, transaction: { description: 'Updated' } }
        expect(response).to redirect_to(account_webapp_transactions_path(account_id: account.id))
      end
    end

    context 'with invalid params' do
      it 'does not update the transaction' do
        transaction = create(:transaction, account: account, category: category)
        patch :update, params: { account_id: account.id, id: transaction.id, transaction: { description: nil } }
        transaction.reload
        expect(transaction.description).not_to be_nil
      end

      it 'renders the edit template' do
        transaction = create(:transaction, account: account, category: category)
        patch :update, params: { account_id: account.id, id: transaction.id, transaction: { description: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end
end
