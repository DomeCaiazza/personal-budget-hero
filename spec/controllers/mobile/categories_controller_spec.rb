require 'rails_helper'

RSpec.describe Mobile::CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  before do
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns the current user\'s categories to @categories' do
      category = create(:category, user: user)
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'initializes a new category' do
        get :new
        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new category' do
          expect {
            post :create, params: { category: attributes_for(:category) }
          }.to change(Category, :count).by(1)
        end

        it 'redirects to the new category path' do
          post :create, params: { category: attributes_for(:category) }
          expect(response).to redirect_to(mobile_categories_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new category' do
          expect {
            post :create, params: { category: attributes_for(:category, name: nil) }
          }.to change(Category, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { category: attributes_for(:category, name: nil) }
          expect(response).to render_template(:new)
        end
      end
    end
  end
end