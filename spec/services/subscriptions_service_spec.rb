require 'rails_helper'

RSpec.describe SubscriptionsService, type: :service do
  let(:user) { create(:user) }
  let(:account) { create(:account) }
  let(:subscription) { create(:subscription, account: account, subscription_type: "monthly", default_amount: 10.0, description: "Test Subscription") }
  let(:service) { described_class.new(account) }

  before do
    create(:account_user, user: user, account: account)
  end

  describe "#initialize" do
    context "when user has no subscriptions category" do
      it "creates a subscriptions category" do
        expect { service }.to change { account.categories.subscriptions.count }.by(1)
      end
    end

    context "when user has subscriptions category" do
      before { create(:category, account: account, category_type: :subscriptions) }

      it "does not create a new subscriptions category" do
        expect { service }.not_to change { account.categories.subscriptions.count }
      end
    end
  end

  describe "#apply" do
    before do
      subscription_category = account.categories.subscriptions.first || create(:category, account: account, category_type: :subscriptions)
      create(:transaction, account: account, category: subscription_category, subscription_code: subscription.code, date: 2.months.ago)
      account.subscriptions << subscription
    end

    it "creates a new transaction if renewal is needed" do
      expect { service.apply }.to change { account.transactions.count }.by(1)
    end

    it "does not create a new transaction if renewal is not needed" do
      subscription_category = account.categories.subscriptions.first || create(:category, account: account, category_type: :subscriptions)
      create(:transaction, account: account, category: subscription_category, subscription_code: subscription.code, date: Time.current)
      expect { service.apply }.not_to change { account.transactions.count }
    end
  end
end
