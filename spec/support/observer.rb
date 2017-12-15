RSpec.configure do |config|
  config.before(:example) do |example|
    PowerTypes::Observable.observable_disabled = !example.metadata[:observers]
  end
end
