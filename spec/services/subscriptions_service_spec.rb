require 'rails_helper'

RSpec.describe SubscriptionsService, type: :service do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, user: user, subscription_type: "monthly", default_amount: 10.0, description: "Test Subscription") }
  let(:service) { described_class.new(user) }

  describe "#initialize" do
    context "when user has no subscriptions category" do
      it "creates a subscriptions category" do
        expect { service }.to change { user.categories.subscriptions.count }.by(1)
      end
    end

    context "when user has subscriptions category" do
      before { create(:category, user: user, category_type: :subscriptions) }

      it "does not create a new subscriptions category" do
        expect { service }.not_to change { user.categories.subscriptions.count }
      end
    end
  end

  describe "#apply" do
    before do
      create(:transaction, user: user, subscription_code: subscription.code, date: 2.months.ago)
      user.subscriptions << subscription
    end

    it "creates a new transaction if renewal is needed" do
      expect { service.apply }.to change { user.transactions.count }.by(1)
    end

    it "does not create a new transaction if renewal is not needed" do
      create(:transaction, user: user, subscription_code: subscription.code, date: Time.current)
      expect { service.apply }.not_to change { user.transactions.count }
    end
  end
end