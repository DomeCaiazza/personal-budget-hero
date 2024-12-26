require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'admin role is recognized' do
    expect(Role.admin?("admin")).to be true
  end

  it 'non-admin role is not recognized as admin' do
    expect(Role.admin?("user")).to be false
    expect(Role.admin?("guest")).to be false
  end

  it 'user role is recognized' do
    expect(Role.user?("user")).to be true
  end

  it 'non-user role is not recognized as user' do
    expect(Role.user?("admin")).to be false
    expect(Role.user?("guest")).to be false
  end

  it 'all roles are listed' do
    roles = Role.all
    expect(roles.size).to eq(2)
    expect(roles).to include([ I18n.t("roles.admin"), "admin" ])
    expect(roles).to include([ I18n.t("roles.user"), "user" ])
  end
end
