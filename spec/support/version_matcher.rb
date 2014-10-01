require 'rspec/expectations'

RSpec::Matchers.define :be_a_version do |expected|
  match do |actual|
    expect(actual.package_name).to eq(expected.fetch('Package'))
    expect(actual.code).to eq(expected.fetch('Version'))
    expect(actual.title).to eq(expected.fetch('Title'))
    expect(actual.description).to eq(expected.fetch('Description'))
    expect(actual.authors).to eq(expected.fetch('Author'))
    expect(actual.maintainers).to eq(expected.fetch('Maintainer'))
    expect(actual.published_at.to_s(:db))
    .to eq(expected.fetch('Date/Publication'))
  end
end