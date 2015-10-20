class Oystercard

  LIMIT = 90
  MINIMUM = 1
  attr_reader :balance


  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(money)
    fail "The topup limit is £#{LIMIT}" if @balance + money > 90
    @balance += money
  end

  def touch_in
    fail "Insufficient Funds. Minimum amount required is #{MINIMUM}" if @balance < MINIMUM
    @in_use = true
  end

  def touch_out
    deduct 
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private

  def deduct
    @balance-=MINIMUM
  end
end
