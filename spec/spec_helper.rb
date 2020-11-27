# frozen_string_literal: true

require 'bundler/setup'
require 'rdown'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus

  config.run_all_when_everything_filtered = true
end

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/json'

RSpec::Matchers.define :be_as_json do |expected|
  match do |actual|
    target = actual.as_json
    target = begin
      case target
      when Array
        target.map(&:deep_symbolize_keys)
      when Hash
        target.deep_symbolize_keys
      else
        target
      end
    end
    values_match? expected, target
  end
end
