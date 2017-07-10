class VendingMachine

  def get_display
    'INSERT COINS'
  end

  def valid_coin?(coin)
    if coin == 3
      true
    end
  end
end