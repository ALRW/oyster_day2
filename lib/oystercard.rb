class Oystercard

  LIMIT = 90
  MINIMUM = 1
  attr_reader :balance, :entry_station, :history


  def initialize
    @balance = 0
    @history = []
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > 90
    @balance += money
  end

  def touch_in(station)
    @entry_station = station
    fail "Insufficient Funds. Minimum amount required is #{MINIMUM}" if @balance < MINIMUM
    @in_use = true
  end

  def touch_out(station)
    @history << {@entry_station => station}
    @entry_station = nil
    deduct
    @in_use = false
  end

  def in_journey?
    !!(@entry_station)
  end

  private

  def deduct
    @balance-=MINIMUM
  end
end
