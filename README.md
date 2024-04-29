# Fetch Users Rails Application

This Rails application includes jobs to fetch user data from an external API, store it in the database, and tabulate daily records. It uses Sidekiq for background job processing, PostgreSQL for the database, and Redis for storing gender counts.

## Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/fetch-users.git
    cd fetch-users
    ```

2. **Install dependencies:**

    ```bash
    bundle install
    ```

3. **Setup the database:**

    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Start the Rails server:**

    ```bash
    rails server
    ```

5. **Start Sidekiq for background job processing:**

    ```bash
    bundle exec sidekiq
    ```

6. **Visit `http://localhost:3000` in your browser to access the application.**

## Running Tests

To run the RSpec tests for this application, execute the following command:

```bash
bundle exec rspec
