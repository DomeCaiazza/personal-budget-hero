require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'currency_formatter' do
    it 'formats a positive amount correctly' do
      expect(helper.currency_formatter(1234.56)).to eq("€1.234,56")
    end

    it 'formats a negative amount correctly' do
      expect(helper.currency_formatter(-1234.56)).to eq("€-1.234,56")
    end

    it 'returns "-" for nil amount' do
      expect(helper.currency_formatter(nil)).to eq("-")
    end

    it 'formats zero amount correctly' do
      expect(helper.currency_formatter(0)).to eq("€0,00")
    end

    it 'formats a large amount correctly' do
      expect(helper.currency_formatter(1234567890.12)).to eq("€1.234.567.890,12")
    end
  end
end
