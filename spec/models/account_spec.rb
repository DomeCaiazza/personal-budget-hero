require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:account_users).dependent(:destroy) }
    it { should have_many(:users).through(:account_users) }
    it { should have_many(:transactions).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'dependent destroy behavior' do
    let(:account) { create(:account) }

    context 'when account is destroyed' do
      it 'destroys associated transactions' do
        create(:transaction, account: account)
        expect { account.destroy }.to change { Transaction.count }.by(-1)
      end

      it 'destroys associated categories' do
        create(:category, account: account)
        expect { account.destroy }.to change { Category.count }.by(-1)
      end

      it 'destroys associated subscriptions' do
        create(:subscription, account: account)
        expect { account.destroy }.to change { Subscription.count }.by(-1)
      end
    end
  end

  describe 'creating an account' do
    it 'is valid with a name' do
      account = build(:account, name: 'Test Account')
      expect(account).to be_valid
    end

    it 'is invalid without a name' do
      account = build(:account, name: nil)
      expect(account).not_to be_valid
      expect(account.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with an empty name' do
      account = build(:account, name: '')
      expect(account).not_to be_valid
    end
  end
end
