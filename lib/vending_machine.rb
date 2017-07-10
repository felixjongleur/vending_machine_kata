class VendingMachine

  attr_accessor :credits, :coin_return, :product_bin, :item_selected, :insufficient_funds

  def initialize
    @credits = 0
    @coin_return = 0
  end

  def get_display
    if insufficient_funds
      @insufficient_funds = false
      return '$0.50'
    end

    if item_selected
      @item_selected = false
      return 'THANK YOU'
    end

    if credits == 0
      return 'INSERT COINS'
    end

    '$%.2f' % (credits.to_i/100.0)
  end

  def get_credits
    credits
  end

  def check_coin_return
    coin_return
  end

  def select_item(item)
    if credits < item.price
      @insufficient_funds = true
    else
      @item_selected = true
      @product_bin = item
      @credits = 0
    end
  end

  def check_product_bin
    product_bin
  end

  def return_coins
    @coin_return += credits
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