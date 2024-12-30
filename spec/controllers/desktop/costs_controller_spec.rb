require 'rails_helper'

RSpec.describe Desktop::CostsController, type: :controller do
  let(:user) { create(:user) }
  let(:cost) { create(:cost, user: user) }

  before do
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @costs' do
      get :index
      expect(assigns(:costs)).to eq([ cost ])
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new cost to @cost' do
      get :new
      expect(assigns(:cost)).to be_a_new(Cost)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      cost = create(:cost, user: user)
      get :edit, params: { id: cost.id }
      expect(response).to be_successful
    end

    it 'assigns the requested cost to @cost' do
      cost = create(:cost, user: user)
      get :edit, params: { id: cost.id }
      expect(assigns(:cost)).to eq(cost)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Cost' do
        expect {
          post :create, params: { cost: attributes_for(:cost).merge(category_id: create(:category).id) }
          cost = assigns(:cost)
          puts cost.errors.full_messages unless cost.persisted? # Add this line to print validation errors
        }.to change(Cost, :count).by(1)
      end

      it 'redirects to the new cost path' do
        post :create, params: { cost: attributes_for(:cost).merge(category_id: create(:category).id) }
        expect(response).to redirect_to(desktop_costs_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new Cost' do
        expect {
          post :create, params: { cost: attributes_for(:cost, description: nil).merge(category_id: create(:category).id) }
        }.to change(Cost, :count).by(0)
      end

      it 'renders the new template' do
        post :create, params: { cost: attributes_for(:cost, description: nil).merge(category_id: create(:category).id) }
        expect(response).to render_template(:new)
      end

      it 'renders the new template' do
        post :create, params: { cost: attributes_for(:cost, description: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested cost' do
        cost = create(:cost, user: user)
        patch :update, params: { id: cost.id, cost: { description: 'Updated' } }
        cost.reload
        expect(cost.description).to eq('Updated')
      end

      it 'redirects to the costs path' do
        cost = create(:cost, user: user)
        patch :update, params: { id: cost.id, cost: { description: 'Updated' } }
        expect(response).to redirect_to(desktop_costs_path)
      end
    end

    context 'with invalid params' do
      it 'does not update the cost' do
        cost = create(:cost, user: user)
        patch :update, params: { id: cost.id, cost: { description: nil } }
        cost.reload
        expect(cost.description).not_to be_nil
      end

      it 'renders the edit template' do
        cost = create(:cost, user: user)
        patch :update, params: { id: cost.id, cost: { description: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the cost is successfully destroyed' do
      it 'redirects to the costs path with a success message' do
        delete :destroy, params: { id: cost.id }
        expect(response).to redirect_to(desktop_costs_path)
        expect(flash[:success]).to eq(I18n.t("labels.record_destroyed"))
      end
    end

    context 'when the cost cannot be destroyed' do
      before do
        allow_any_instance_of(Cost).to receive(:destroy).and_return(false)
      end

      it 'redirects to the costs path with an error message' do
        delete :destroy, params: { id: cost.id }
        expect(response).to redirect_to(desktop_costs_path)
        expect(flash[:danger]).to include(I18n.t("labels.error_record_destroyed"))
      end
    end

    context 'when the user is not authorized' do
      let(:other_user) { create(:user) }
      let(:other_cost) { create(:cost, user: other_user) }

      it 'raises a ActiveRecord::RecordNotFound' do
        expect {
          delete :destroy, params: { id: other_cost.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
