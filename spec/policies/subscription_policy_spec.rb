require 'rails_helper'

RSpec.describe SubscriptionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:guest) { create(:user, role: 'guest') }
  let(:scope) { Transaction.all }

  describe 'Scope' do
    it 'returns all subscriptions for admin' do
      expect(SubscriptionPolicy::Scope.new(admin, scope).resolve).to match_array(scope)
    end

    it 'returns all subscriptions for user' do
      expect(SubscriptionPolicy::Scope.new(user, scope).resolve).to match_array(scope)
    end

    it 'returns no subscriptions for guest' do
      expect(SubscriptionPolicy::Scope.new(guest, scope).resolve).to be_empty
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(SubscriptionPolicy.new(admin, Subscription).index?).to be true
    end

    it 'allows access for user' do
      expect(SubscriptionPolicy.new(user, Subscription).index?).to be true
    end

    it 'denies access for guest' do
      expect(SubscriptionPolicy.new(guest, Subscription).index?).to be false
    end
  end

  describe 'generate_slug?' do
    it 'allows access for admin' do
      expect(SubscriptionPolicy.new(admin, Subscription).generate_slug?).to be true
    end

    it 'allows access for user' do
      expect(SubscriptionPolicy.new(user, Subscription).generate_slug?).to be true
    end

    it 'denies access for guest' do
      expect(SubscriptionPolicy.new(guest, Subscription).generate_slug?).to be false
    end
  end
end
