class VendingMachine

  def get_display
    'INSERT COINS'
  end

  def get_credits
    0
  end

  def insert_coin(coin)

  end

  def valid_coin?(coin)
    if coin == 2
     return false
    end
    true
  end
end