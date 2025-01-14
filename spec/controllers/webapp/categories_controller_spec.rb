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
      expect(assigns(:categories)).to eq([ category ])
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
          expect(response).to redirect_to(webapp_categories_path)
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

    describe 'GET #edit' do
      context 'when the user is authorized' do
        it 'returns a success response' do
          get :edit, params: { id: category.id }
          expect(response).to be_successful
        end

        it 'assigns the requested category to @category' do
          get :edit, params: { id: category.id }
          expect(assigns(:category)).to eq(category)
        end
      end

      context 'when the user is not authorized' do
        it 'raises a ActiveRecord::RecordNotFound' do
          other_user = create(:user)
          other_category = create(:category, user: other_user)
          expect {
            get :edit, params: { id: other_category.id }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid parameters' do
        it 'updates the category' do
          patch :update, params: { id: category.id, category: { name: 'Updated Name' } }
          category.reload
          expect(category.name).to eq('Updated Name')
        end

        it 'redirects to the categories path' do
          patch :update, params: { id: category.id, category: { name: 'Updated Name' } }
          expect(response).to redirect_to(webapp_categories_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not update the category' do
          patch :update, params: { id: category.id, category: { name: nil } }
          category.reload
          expect(category.name).not_to be_nil
        end

        it 'renders the edit template' do
          patch :update, params: { id: category.id, category: { name: nil } }
          expect(response).to render_template(:edit)
        end
      end

      context 'when the user is not authorized' do
        it 'raises a ActiveRecord::RecordNotFound' do
          other_user = create(:user)
          other_category = create(:category, user: other_user)
          expect {
            patch :update, params: { id: other_category.id, category: { name: 'Updated Name' } }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
