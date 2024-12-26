require 'rails_helper'

RSpec.describe Mobile::CostsController, type: :controller do
  let(:user) { create(:user) }

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
      cost = create(:cost, user: user)
      get :index
      expect(assigns(:costs)).to eq([cost])
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
        expect(response).to redirect_to(new_mobile_cost_path)
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
        expect(response).to redirect_to(mobile_costs_path)
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
end