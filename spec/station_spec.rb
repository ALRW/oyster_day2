require 'station'

describe Station do
  it 'should respond to zone' do
    expect(subject).to respond_to(:zone)
  end
end
