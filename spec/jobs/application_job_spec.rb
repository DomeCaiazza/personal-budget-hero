require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  describe 'default behavior' do
    it 'inherits from ActiveJob::Base' do
      expect(ApplicationJob.superclass).to eq(ActiveJob::Base)
    end
  end
end
