# Smarty Address Validation

## Instructions

### Prerequisites

#### Clone the repository

If you want to use ssh and have not already enabled it, follow these [instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

```bash
git clone git@github.com:vancourtj/smarty_address_validation.git
```

#### rbenv

Make sure you have rbenv installed:

```bash
rbenv -v
```

If you do not have rbenv installed, follow these [instructions](https://github.com/rbenv/rbenv#installation).

#### Ruby

This project was written in Ruby [3.1.4](https://www.ruby-lang.org/en/news/2023/03/30/ruby-3-1-4-released/).

You can check your Ruby installation:

```bash
ruby -v
```

If you do not have ruby or the correct version installed:

```bash
rbenv install 3.1.4
rbenv local 3.1.4
```

#### Bundler

Make sure you have bundler installed:

```bash
bundler -v
```

If you do not have bundler installed:

```bash
gem install bundler
```

Then, install the gems for this project:

```bash
bundle install
```

### Smarty API Credentials

You can set the credentials in `.env` by replacing the values for `SMARTY_AUTH_ID` and `SMARTY_AUTH_TOKEN` with your own secret keys.

Secret keys can be found in the "API Keys" tab of your Smarty account page.

Sign up for a free trial [here](https://www.smarty.com/products/us-address-verification).

### Script

With everything installed, you can run the script from the project directory with:

```bash
bundle exec ruby address_validation.rb --csv_file_name spec/fixtures/sample_data.csv
```

This will run it with a valid csv from the spec fixtures section. You could run the script with any csv by replacing `spec/fixtures/sample_data.csv` with the file path of your choice.

### Tests

You can run the entire test suite from the project directory with:

```bash
bundle exec rspec
```

You can also run individual spec files from the project directory. For example:

```bash
bundle exec rspec spec/services/smarty_address_service_spec.rb
```

## Design Choices

### Assumptions
- the input csv file shape and data do not need validated
- only the first Smarty result candidate matters, we don't need to ask for or care about additional candidates

### Script

The script file interacts with the command line (takes in arguments and prints to terminal)
and loads the environment variables early in code execution. All other responsibilities get handed
off to different services. This provides a command-line program for the script and allows for the
Smarty integration code to be easily reusable and extendable.

### Services

#### File Name Parsing

This service provides a testable interface for retrieving the cli file name argument.

#### Smarty Address

This service uses the `SmartyAdapter` to retrieve the Smarty validated address.
It then formats the original and validated addresses for downstream consumption.

It can easily be extended and used without worrying about the
specific implementation of the Smarty integration. The service only needs to concern
itself with the original address and the API response shape.

#### Address Format

This removes string formatting responsibility from the script and puts it into a flexible,
testable service. There is logic for what to use when there is not a valid address.

### Smarty Integration

The integration heavily relies on the [Smarty SDK](https://github.com/smartystreets/smartystreets-ruby-sdk/tree/master)
for ease of implementation and maintainability. The integration is wrapped in an adapter-client pattern.

The adapter acts as the interface for the codebase to isolate the client and transforms address data into
the sdk preferred format. The client handles building the sdk client and sending the request.
