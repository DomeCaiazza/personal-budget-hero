require 'rails_helper'

RSpec.describe Desktop::TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }
  let(:categories) { double('categories') }

  before do
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:categories).and_return(categories)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @transactions' do
      get :index
      expect(assigns(:transactions)).to eq([ transaction ])
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new transaction to @transaction' do
      get :new
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      transaction = create(:transaction, user: user)
      get :edit, params: { id: transaction.id }
      expect(response).to be_successful
    end

    it 'assigns the requested transaction to @transaction' do
      transaction = create(:transaction, user: user)
      get :edit, params: { id: transaction.id }
      expect(assigns(:transaction)).to eq(transaction)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Transaction' do
        expect {
          post :create, params: { transaction: attributes_for(:transaction).merge(category_id: create(:category).id) }
          transaction = assigns(:transaction)
          puts transaction.errors.full_messages unless transaction.persisted? # Add this line to print validation errors
        }.to change(Transaction, :count).by(1)
      end

      it 'redirects to the new transaction path' do
        post :create, params: { transaction: attributes_for(:transaction).merge(category_id: create(:category).id) }
        expect(response).to redirect_to(desktop_transactions_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Transaction' do
        expect {
          post :create, params: { transaction: attributes_for(:transaction, description: nil).merge(category_id: create(:category).id) }
        }.to change(Transaction, :count).by(0)
      end

      it 'renders the new template' do
        post :create, params: { transaction: attributes_for(:transaction, description: nil).merge(category_id: create(:category).id) }
        expect(response).to render_template(:new)
      end

      it 'renders the new template' do
        post :create, params: { transaction: attributes_for(:transaction, description: nil) }
        expect(response).to render_template(:new)
      end
    end

    context '#set_category' do
      it 'creates a new income transaction with correct category type' do
        expect {
          post :create, params: { transaction: attributes_for(:transaction, transaction_type: 'income')
                                                 .merge(category_id: create(:category, category_type: 'incomes').id) }
        }.to change(Transaction.incomes, :count).by(1)
      end

      it 'creates a new income transaction with correct category type' do
        expect {
          post :create, params: { transaction: attributes_for(:transaction, transaction_type: 'expense')
                                                 .merge(category_id: create(:category, category_type: 'expenses').id) }
        }.to change(Transaction.expenses, :count).by(1)
      end

      it 'does not create a new transaction with correct category type' do
        expect {
          post :create, params: { transaction: attributes_for(:transaction, transaction_type: 'expense')
                                                 .merge(category_id: create(:category, category_type: 'invalid').id) }
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested transaction' do
        transaction = create(:transaction, user: user)
        patch :update, params: { id: transaction.id, transaction: { description: 'Updated' } }
        transaction.reload
        expect(transaction.description).to eq('Updated')
      end

      it 'redirects to the transactions path' do
        transaction = create(:transaction, user: user)
        patch :update, params: { id: transaction.id, transaction: { description: 'Updated' } }
        expect(response).to redirect_to(desktop_transactions_path)
      end
    end

    context 'with invalid params' do
      it 'does not update the transaction' do
        transaction = create(:transaction, user: user)
        patch :update, params: { id: transaction.id, transaction: { description: nil } }
        transaction.reload
        expect(transaction.description).not_to be_nil
      end

      it 'renders the edit template' do
        transaction = create(:transaction, user: user)
        patch :update, params: { id: transaction.id, transaction: { description: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the transaction is successfully destroyed' do
      it 'redirects to the transactions path with a success message' do
        delete :destroy, params: { id: transaction.id }
        expect(response).to redirect_to(desktop_transactions_path)
        expect(flash[:success]).to eq(I18n.t("labels.record_destroyed"))
      end
    end

    context 'when the transaction cannot be destroyed' do
      before do
        allow_any_instance_of(Transaction).to receive(:destroy).and_return(false)
      end

      it 'redirects to the transactions path with an error message' do
        delete :destroy, params: { id: transaction.id }
        expect(response).to redirect_to(desktop_transactions_path)
        expect(flash[:danger]).to include(I18n.t("labels.error_record_destroyed"))
      end
    end

    context 'when the user is not authorized' do
      let(:other_user) { create(:user) }
      let(:other_transaction) { create(:transaction, user: other_user) }

      it 'raises a ActiveRecord::RecordNotFound' do
        expect {
          delete :destroy, params: { id: other_transaction.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
