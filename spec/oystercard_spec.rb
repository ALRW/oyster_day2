require 'oystercard'
describe Oystercard do
  let(:station) {double(:station)}
  it 'card has balance' do
    expect(subject.balance).to be_truthy
    # expect(subject.balance).to be(0)
  end

  it ' has no journey history when created' do
    expect(subject.history).to be_empty
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
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end

    it "should raise an error if there is not enough money" do
      expect{subject.touch_in(station)}.to raise_error "Insufficient Funds. Minimum amount required is #{Oystercard::MINIMUM}"
    end

    it 'should record station upon touch_in' do
      subject.top_up(10)
      subject.touch_in(station)
      expect(subject.entry_station).to eq(station)
    end
  end

  describe '#touch_out' do
    let(:station1) {double(:station1)}
    it 'should not be in journey when touched out' do
      subject.top_up 10
      subject.touch_in(station)
       subject.touch_out(station1)
      expect(subject).not_to be_in_journey
    end
    it 'should charge me when I touch out' do
      expect{subject.touch_out(station1)}.to change{subject.balance}.by(-Oystercard::MINIMUM)
    end

    it 'should  record station upon touching out' do
      subject.top_up 10
      subject.touch_in station
      subject.touch_out station1
      expect(subject.history). to include({station => station1})
    end
  end
end
