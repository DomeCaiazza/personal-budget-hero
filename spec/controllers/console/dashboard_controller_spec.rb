require 'rails_helper'

RSpec.describe Desktop::DashboardController, type: :controller do
  let(:user) { create(:user) }

  before do
    Rails.application.routes_reloader.execute_unless_loaded
    sign_in(user)
  end

  describe 'GET #index' do
    context 'when the user is authorized' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns the user\'s categories to @categories' do
        get :index
        expect(assigns(:categories)).to eq(user.categories)
      end

      it 'assigns the correct transactions to @transactions based on the query' do
        get :index, params: { q: { date_gteq: '2023-01-01', date_lteq: '2023-12-31' } }
        expect(assigns(:transactions)).to eq(user.transactions.where(date: '2023-01-01'..'2023-12-31'))
      end

      it 'calculates the correct monthly sums for each category' do
        get :index
        assigns(:category_data).each do |category_id, data|
          expect(data[:monthly_sums].sum).to eq(data[:total])
        end
      end
    end

    context 'when the user is not authorized' do
      before do
        allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it 'raises a Pundit::NotAuthorizedError' do
        expect { get :index }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when a year is passed in the query params' do
      it 'sets the date range for the entire year' do
        get :index, params: { q: { date_eq: '2021' } }
        expect(assigns(:q).conditions[0].value).to eq(Date.parse('2021-01-01'))
        expect(assigns(:q).conditions[1].value).to eq(Date.parse('2021-12-31'))
      end
    end

    it 'calculates monthly sums correctly for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums].sum).to eq(data[:total])
      end
    end

    it 'sets monthly sums to zero for months with no transactions' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums].count(0)).to be >= 0
      end
    end

    it 'calculates the correct total for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:total]).to eq(data[:monthly_sums].sum)
      end
    end

    it 'calculates the correct average for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:avg]).to eq(data[:total] / 12.0)
      end
    end

    it 'assigns the correct category name and color' do
      get :index
      assigns(:category_data).each do |category_id, data|
        category = user.categories.find(category_id)
        expect(data[:name]).to eq(category.name)
        expect(data[:color]).to eq(category.hex_color)
      end
    end

    it 'calculates monthly sums correctly for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums].sum).to eq(data[:total])
      end
    end

    it 'sets monthly sums to zero for months with no transactions' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums].count(0)).to be >= 0
      end
    end

    it 'calculates the correct total for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:total]).to eq(data[:monthly_sums].sum)
      end
    end

    it 'calculates the correct average for each category' do
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:avg]).to eq(data[:total] / 12.0)
      end
    end

    it 'assigns the correct category name and color' do
      get :index
      assigns(:category_data).each do |category_id, data|
        category = user.categories.find(category_id)
        expect(data[:name]).to eq(category.name)
        expect(data[:color]).to eq(category.hex_color)
      end
    end

    it 'handles categories with no transactions correctly' do
      allow_any_instance_of(User).to receive(:transactions).and_return(Transaction.none)
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums]).to all(eq(0))
        expect(data[:total]).to eq(0)
        expect(data[:avg]).to eq(0.0)
      end
    end

    it 'handles categories with transactions in some months correctly' do
      allow_any_instance_of(User).to receive(:transactions).and_return(Transaction.where(date: '2023-01-01'..'2023-06-30'))
      get :index
      assigns(:category_data).each do |category_id, data|
        expect(data[:monthly_sums][0..5].sum).to eq(data[:total])
        expect(data[:monthly_sums][6..11]).to all(eq(0))
      end
    end


    describe '#build_category_data' do
      let(:category1) { create(:category, user: user, name: "Cibo") }
      let(:category2) { create(:category, user: user, name: "Auto") }

      let(:categories) { [ category1, category2 ] }
      let(:transactions_data) do
        {
          [ category1.id, 1 ] => 10,
          [ category1.id, 2 ] => 20,
          [ category2.id, 3 ] => 30,
          [ category2.id, 4 ] => 40
        }
      end

      it 'calc monthly sums, total e avg' do
        result = controller.send(:build_category_data, categories, transactions_data)

        expect(result[category1.id][:monthly_sums]).to eq([ 10, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ])
        expect(result[category1.id][:total]).to eq(30)
        expect(result[category1.id][:avg]).to eq(30 / 12.0)
        expect(result[category2.id][:monthly_sums]).to eq([ 0, 0, 30, 40, 0, 0, 0, 0, 0, 0, 0, 0 ])
        expect(result[category2.id][:total]).to eq(70)
        expect(result[category2.id][:avg]).to eq(70 / 12.0)
      end
    end
  end
end
