class VendingMachine

  attr_accessor :credits

  def get_display
    'INSERT COINS'
  end

  def get_credits
    credits
  end

  def insert_coin(coin)
    @credits = 5
  end

  def valid_coin?(coin)
    if coin == 2
     return false
    end
    true
  end
end