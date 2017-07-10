class VendingMachine

  attr_accessor :credits, :coin_return

  def initialize
    @credits = 0
    @coin_return = 0
  end

  def get_display
    if @credits == 0
      return 'INSERT COINS'
    end

    '$%.2f' % (@credits.to_i/100.0)
  end

  def get_credits
    credits
  end

  def check_coin_return
    coin_return
  end

  def return_coins
    @coin_return += @credits
    @credits = 0
  end

  def insert_coin(coin)
    if valid_coin? coin
      @credits += get_value(coin)
    else
      @coin_return += get_value(coin)
    end
  end

  def get_value(coin)
    case coin
      when 3
        return 5
      when 1
        return 10
      when 4
        return 25
      when 2
        return 1
      else
        return 0
    end
  end

  def valid_coin?(coin)
    if coin == 2
     return false
    end
    true
  end
end