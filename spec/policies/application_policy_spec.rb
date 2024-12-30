# spec/policies/application_policy_spec.rb
require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  let(:user) { instance_double('User') }
  let(:record) { double('Record') }
  subject(:policy) { described_class.new(user, record) }

  describe '#index?' do
    it 'returns false by default' do
      expect(policy.index?).to eq(false)
    end
  end

  describe '#show?' do
    it 'behaves like #index?' do
      expect(policy.show?).to eq(false)
    end
  end

  describe '#user_has_admin_or_user_privileges?' do
    context 'when user is admin' do
      it 'returns true' do
        allow(user).to receive(:admin?).and_return(true)
        allow(user).to receive(:user?).and_return(false)
        expect(policy.user_has_admin_or_user_privileges?).to eq(true)
      end
    end

    context 'when user is regular' do
      it 'returns true' do
        allow(user).to receive(:admin?).and_return(false)
        allow(user).to receive(:user?).and_return(true)
        expect(policy.user_has_admin_or_user_privileges?).to eq(true)
      end
    end

    context 'when user is neither admin nor regular' do
      it 'returns false' do
        allow(user).to receive(:admin?).and_return(false)
        allow(user).to receive(:user?).and_return(false)
        expect(policy.user_has_admin_or_user_privileges?).to eq(false)
      end
    end
  end

  describe 'alias methods' do
    it 'create?, new?, update?, destroy? behave like index?' do
      expect(policy.create?).to eq(false)
      expect(policy.new?).to eq(false)
      expect(policy.update?).to eq(false)
      expect(policy.destroy?).to eq(false)
    end
  end

  describe ApplicationPolicy::Scope do
    let(:scope_instance) { described_class.new(user, double('Scope')) }

    describe '#resolve' do
      it 'raises NoMethodError by default' do
        expect { scope_instance.resolve }.to raise_error(NoMethodError)
      end
    end
  end
end
