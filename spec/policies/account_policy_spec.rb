require 'rails_helper'

RSpec.describe AccountPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:guest) { create(:user, role: 'guest') }
  let(:account) { create(:account) }
  let(:user_account) { create(:account) }
  let(:scope) { Account.all }

  before do
    create(:account_user, user: user, account: user_account)
  end

  describe 'Scope' do
    it 'returns only accounts belonging to the user' do
      other_account = create(:account)
      create(:account_user, user: user, account: other_account)
      
      resolved = AccountPolicy::Scope.new(user, scope).resolve
      expect(resolved).to include(user_account)
      expect(resolved).to include(other_account)
      expect(resolved).not_to include(account)
    end

    it 'returns empty scope for user with no accounts' do
      new_user = create(:user)
      resolved = AccountPolicy::Scope.new(new_user, scope).resolve
      expect(resolved).to be_empty
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(AccountPolicy.new(admin, Account).index?).to be true
    end

    it 'allows access for user' do
      expect(AccountPolicy.new(user, Account).index?).to be true
    end

    it 'denies access for guest' do
      expect(AccountPolicy.new(guest, Account).index?).to be false
    end
  end

  describe 'show?' do
    it 'allows access for user who owns the account' do
      expect(AccountPolicy.new(user, user_account).show?).to be true
    end

    it 'denies access for user who does not own the account' do
      expect(AccountPolicy.new(user, account).show?).to be false
    end
  end

  describe 'new?' do
    it 'allows access for admin' do
      expect(AccountPolicy.new(admin, Account).new?).to be true
    end

    it 'allows access for user' do
      expect(AccountPolicy.new(user, Account).new?).to be true
    end

    it 'denies access for guest' do
      expect(AccountPolicy.new(guest, Account).new?).to be false
    end
  end

  describe 'create?' do
    it 'allows access for admin' do
      expect(AccountPolicy.new(admin, Account).create?).to be true
    end

    it 'allows access for user' do
      expect(AccountPolicy.new(user, Account).create?).to be true
    end

    it 'denies access for guest' do
      expect(AccountPolicy.new(guest, Account).create?).to be false
    end
  end

  describe 'switch?' do
    it 'allows access for user who owns the account' do
      expect(AccountPolicy.new(user, user_account).switch?).to be true
    end

    it 'denies access for user who does not own the account' do
      expect(AccountPolicy.new(user, account).switch?).to be false
    end
  end
end

