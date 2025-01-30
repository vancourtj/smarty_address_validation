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

This project was written in Ruby [3.1.6](https://www.ruby-lang.org/en/news/2024/05/29/ruby-3-1-6-released/).

You can check your Ruby installation:

```bash
ruby -v
```

If you do not have ruby or the correct version installed:

```bash
rbenv install 3.1.6
rbenv local 3.1.6
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
bundle exec rspec spec/models/address_spec.rb
```

## Design Choices

### Assumptions

- the input csv file shape and data do not need validated
- only the first Smarty result candidate matters, we don't need to ask for or care about additional candidates
- error handling is out of scope

### Script

The script file acts mostly as an orchestrator: loads the environment variables early in code execution, loops through the csv file, and loops through the addresses to print them. The script hands off core responsibilities and business logic to different services and classes. The separation of concerns allows for easy extension of the code.

### Services

#### File Name Parsing

This service provides a testable interface for retrieving the cli file name argument.

### Classes

#### Address

The class provides an extendable, testable interface for operations that include or should live at a level above either the input data and the validated address. Instead of calling the Smarty API in the csv parsing loop, that occurs at instantiation of the Address class.

#### Candidate

The class acts as a convenient wrapper for the complex `SmartyStreets::USStreet::Candidate` class and provides useful methods that are only concerned with the Smarty API response candidate.

### Smarty Integration

The integration heavily relies on the [Smarty SDK](https://github.com/smartystreets/smartystreets-ruby-sdk/tree/master)
for ease of implementation and maintainability. The integration is wrapped in an adapter-client pattern.

The adapter acts as the interface for the codebase to isolate the client and transforms address data into
the sdk preferred format. The client handles building the sdk client and sending the request.

## Future Considerations

- Investigate batching the Smarty API requests to improve performance for large datasets
- Implement graceful error handling
- Implement a caching or deduplicating mechanism to prevent redundant Smarty API requests
