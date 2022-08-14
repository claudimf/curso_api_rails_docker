RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all, :cache_context) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before do |example|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after do |example|
    DatabaseCleaner.clean
  end

  config.after(:all, :cache_context) do
    DatabaseCleaner.clean
  end
end
