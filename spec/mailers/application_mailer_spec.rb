require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'default settings' do
    it 'sets the default from email' do
      expect(ApplicationMailer.default[:from]).to eq('from@example.com')
    end

    it 'uses the mailer layout' do
      expect(ApplicationMailer._layout).to eq('mailer')
    end
  end
end
