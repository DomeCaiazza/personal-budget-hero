# Personal Budget Hero

**[English](README.md) | [Italiano](README.it.md)**

It is a web application designed to manage personal finances.
PBH is made by a web console easy user interface and an optimised interface for mobile devices to easily manage transactions to your account.

## Console interface Features

- **Multi-account management**: Create and switch between multiple accounts (wallets)
- **CRUD income and expenses transactions** with advanced filtering (by date range, category, description)
- **CRUD transaction categories** with custom colors and types (expenses, incomes, subscriptions)
- **CRUD subscriptions** (monthly, quarterly, semi-annual, annual) with automatic transaction generation
- **Dashboard** with monthly transactions report by category
- **Transaction reports** with:
  - Total expenses and incomes
  - Savings calculation
  - Expense forecasts
  - Savings forecasts
  - Average daily expenses
- **User authorization** with role-based access control (Pundit)

### Console future Features

- CRUD savings goals to manage savings.

## Mobile interface (Webapp) Features

- **CRUD income and expenses transactions**
- **CRUD transaction categories**

### Mobile future Features

- Graphic interface optimisation.

## Technologies

- **Ruby** 3.3.5
- **Rails** 8.1
- **MySQL** 8
- **Tailwind CSS** 4.4.0
- **Bootstrap** 5.3.3
- **Devise** 4.9 (Authentication)
- **Pundit** 2.4 (Authorization)
- **Ransack** (Advanced search and filtering)
- **Kaminari** (Pagination)
- **Turbo Rails** (Hotwire SPA-like navigation)
- **Stimulus** (JavaScript framework)
- **RSpec** (Testing)

## Installation

1. Clone the repository
```git clone git@github.com:DomeCaiazza/personal-budget-hero.git```
2. Install dependencies
```bundle install```
3. Create the database
```rails db:create```
4. Run the migrations
```rails db:migrate```
5. Run tests
```rspec```
6. Start the server
```rails s```
   
## Usage

1. Open your browser and go to http://localhost:3000
2. Sign up and log in

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Take a look here: https://github.com/users/DomeCaiazza/projects/1

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Author
[Domenico Caiazza](https://domenicocaiazza.com)


