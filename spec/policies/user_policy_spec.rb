require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:scope) { User.all }

  describe 'Scope' do
    it 'returns all users for admin' do
      expect(UserPolicy::Scope.new(admin, scope).resolve).to match_array(scope)
    end

    it 'returns only the user for non-admin' do
      expect(UserPolicy::Scope.new(user, scope).resolve).to match_array(scope.where(id: user.id))
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(UserPolicy.new(admin, user).index?).to be true
    end

    it 'allows access for user' do
      expect(UserPolicy.new(user, user).index?).to be true
    end

    it 'denies access for non-admin and non-user' do
      other_user = create(:user, role: 'guest')
      expect(UserPolicy.new(other_user, user).index?).to be false
    end
  end
end
