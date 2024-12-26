# frozen_string_literal: true
class Role
  ADMIN = 'admin'
  USER = 'user'

  def self.admin?(role)
    role.to_s == ADMIN
  end

  def self.user?(role)
    role.to_s == USER
  end

  def self.all
    [
      [I18n.t('roles.admin'), ADMIN],
      [I18n.t('roles.user'), USER]
    ]
  end

end
