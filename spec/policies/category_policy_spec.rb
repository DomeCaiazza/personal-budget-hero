require 'rails_helper'

RSpec.describe CategoryPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:guest) { create(:user, role: 'guest') }
  let(:scope) { Category.all }

  describe 'Scope' do
    it 'returns all categories for admin' do
      expect(CategoryPolicy::Scope.new(admin, scope).resolve).to match_array(scope)
    end

    it 'returns all categories for user' do
      expect(CategoryPolicy::Scope.new(user, scope).resolve).to match_array(scope)
    end

    it 'returns no categories for guest' do
      expect(CategoryPolicy::Scope.new(guest, scope).resolve).to be_empty
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(CategoryPolicy.new(admin, Category).index?).to be true
    end

    it 'allows access for user' do
      expect(CategoryPolicy.new(user, Category).index?).to be true
    end

    it 'denies access for guest' do
      expect(CategoryPolicy.new(guest, Category).index?).to be false
    end
  end

  describe 'generate_slug?' do
    it 'allows access for admin' do
      expect(CategoryPolicy.new(admin, Category).generate_slug?).to be true
    end

    it 'allows access for user' do
      expect(CategoryPolicy.new(user, Category).generate_slug?).to be true
    end

    it 'denies access for guest' do
      expect(CategoryPolicy.new(guest, Category).generate_slug?).to be false
    end
  end
end
