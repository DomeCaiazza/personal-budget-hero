RSpec.describe Subscription, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:subscription) { FactoryBot.create(:subscription, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subscription).to be_valid
    end

    it 'is invalid without a description' do
      subscription.description = nil
      expect(subscription).not_to be_valid
    end

    it 'is invalid without a default_amount' do
      subscription.default_amount = nil
      expect(subscription).not_to be_valid
    end

    it 'is invalid without a subscription_type' do
      subscription.subscription_type = nil
      expect(subscription).not_to be_valid
    end

    it 'is invalid with a non-unique code' do
      subscription2 = FactoryBot.create(:subscription)
      subscription2.code = subscription.code
      expect(subscription2).not_to be_valid
    end
  end

  describe 'before create callback' do
    it 'generates a unique subscription code' do
      subscription.save
      expect(subscription.code).not_to be_nil
    end
  end
end