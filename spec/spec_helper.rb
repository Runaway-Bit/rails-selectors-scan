Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.color_enabled = true
  config.fail_fast = true

  # Fakefs tags
  config.include FakeFS::SpecHelpers, fakefs: true
end
