# spec/controllers/console/subscriptions_controller_spec.rb

describe Console::SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, user: user) }

  before do
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: subscription.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Subscription" do
        expect {
          post :create, params: { subscription: attributes_for(:subscription) }
        }.to change(Subscription, :count).by(1)
      end

      it "redirects to the subscriptions list" do
        post :create, params: { subscription: attributes_for(:subscription) }
        expect(response).to redirect_to(console_subscriptions_path)
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :create, params: { subscription: attributes_for(:subscription, description: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested subscription" do
        patch :update, params: { id: subscription.id, subscription: { description: "New Description" } }
        subscription.reload
        expect(subscription.description).to eq("New Description")
      end

      it "redirects to the subscriptions list" do
        patch :update, params: { id: subscription.id, subscription: { description: "New Description" } }
        expect(response).to redirect_to(console_subscriptions_path)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        patch :update, params: { id: subscription.id, subscription: { description: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested subscription" do
      subscription
      expect {
        delete :destroy, params: { id: subscription.id }
      }.to change(Subscription, :count).by(-1)
    end

    it "redirects to the subscriptions list" do
      delete :destroy, params: { id: subscription.id }
      expect(response).to redirect_to(console_subscriptions_path)
    end

    context "when destroy fails" do
      before do
        allow_any_instance_of(Subscription).to receive(:destroy).and_return(false)
      end

      it "does not change the subscription count" do
        subscription
        expect {
          delete :destroy, params: { id: subscription.id }
        }.not_to change(Subscription, :count)
      end

      it "redirects to the subscriptions list with error message" do
        delete :destroy, params: { id: subscription.id }
        expect(response).to redirect_to(console_subscriptions_path)
        expect(flash[:danger]).to eq("<b>#{I18n.t('labels.error_record_destroyed')}</b>: ")
      end
    end
  end
end