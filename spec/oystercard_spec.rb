require 'oystercard'
describe Oystercard do
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end


  describe '#top_up' do

    it {is_expected.to respond_to(:top_up).with(1).argument}

    it 'can top up the balance' do
      expect {subject.top_up(1)}.to change{subject.balance}.by 1
    end

    it 'fails if more than £90 is added' do
      expect{subject.top_up(100)}.to raise_error("The topup limit is £#{Oystercard::LIMIT}")
    end
  end

  describe "#touch_in" do
    it "should be in journey when touched in" do
      subject.top_up 10
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it "should raise an error if there is not enough money" do
      expect{subject.touch_in}.to raise_error "Insufficient Funds. Minimum amount required is #{Oystercard::MINIMUM}"
    end
  end

  describe '#touch_out' do
    it 'should not be in journey when touched out' do
      subject.top_up 10
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
    it 'should charge me when I touch out' do
      expect{subject.touch_out}.to change{subject.balance}.by(-Oystercard::MINIMUM)
    end
  end
end
