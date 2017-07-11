class VendingMachine

  attr_accessor :credits, :coin_return, :product_bin, :item_selected, :insufficient_funds
  attr_accessor :inventory, :item_sold_out, :prices

  def initialize
    @credits = 0
    @coin_return = 0
    @inventory = {}
    @prices = {}
    set_price 'Pop', 100
    set_price 'Chips', 50
    set_price 'Candy', 65
  end

  def set_price(name, price)
    @prices[name] = price
  end

  def get_price(name)
    @prices[name]
  end

  def get_display
    if item_sold_out
      @item_sold_out = false
      return 'SOLD OUT'
    end

    if insufficient_funds
      @insufficient_funds = false
      display = format_to_money get_price(item_selected.name)
      @item_selected = nil
      return display
    end

    if item_selected
      @item_selected = nil
      return 'THANK YOU'
    end

    if credits == 0
      return 'INSERT COINS'
    end

    format_to_money credits
  end

  def format_to_money(amount)
    '$%.2f' % (amount.to_i/100.0)
  end

  def get_credits
    credits
  end

  def check_coin_return
    coin_return
  end

  def add_to_inventory(item)
    if @inventory.has_key? item.name
      @inventory[item.name].push item
    else
      @inventory[item.name] = [item]
    end
  end

  def check_stock(item)
    if @inventory.has_key? item.name
      return true
    end
    false
  end

  def select_item(item)
    unless check_stock item
      @item_sold_out = true
      return
    end

    @item_selected = item
    if credits < get_price(item.name)
      @insufficient_funds = true
    else
      @product_bin = item
      @coin_return += (credits - get_price(item.name))
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