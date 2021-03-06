require_relative '../lib/coin'

class VendingMachine

  attr_accessor :credits, :coin_return, :product_bin, :item_selected, :insufficient_funds
  attr_accessor :inventory, :item_sold_out, :prices, :menus, :current_menu, :running

  def initialize
    @credits = 0
    @coin_return = 0
    @product_bin = []
    @inventory = {}
    @prices = {}
    set_price 'Pop', 100
    set_price 'Chips', 50
    set_price 'Candy', 65

    @current_menu = 'MAIN'
    @menus = {}
    @menus['MAIN'] = ['1) INSERT COIN', '2) SELECT ITEM', '3) TAKE FROM BIN', '4) RETURN COINS', '5) TAKE FROM COIN RETURN', '6) TURN OFF']
    @menus['INSERT COIN'] = ['1) PENNY', '2) NICKEL', '3) DIME', '4) QUARTER', '5) BACK']

    @running = true
  end

  def is_running?
    running
  end

  def process_input(input)
    case current_menu
      when 'MAIN'
        case input
          when 1
            @current_menu = 'INSERT COIN'
          when 2
            @current_menu = 'SELECT PRODUCT'
          when 3
            pick_up_item
          when 4
            return_coins
          when 5
            check_coin_return
          when 6
            @running = false
          else
            # type code here
        end
      when 'INSERT COIN'
        case input
          when 1
            insert_coin Coin::PENNY
            'Pennies are not accepted!'
          when 2
            insert_coin Coin::NICKEL
            'A nickel has been inserted!'
          when 3
            insert_coin Coin::DIME
            'A dime has been inserted!'
          when 4
            insert_coin Coin::QUARTER
            'A quarter has been inserted!'
          when 5
            @current_menu = 'MAIN'
          else
        end
      when 'SELECT PRODUCT'
        generate_product_menu
        case input
          when 4
            @current_menu = 'MAIN'
          else
            select_item @menus['SELECT PRODUCT'][input - 1].split(' ')[1].capitalize
        end
    end
  end

  def generate_product_menu
    if @inventory.empty?
      menu = ['NO PRODUCTS AVAILABLE!']
    else
      menu = []
      item_number = 1
      @inventory.each_key do |product|
        menu << "#{item_number}) #{product.upcase}"
        item_number += 1
      end
    end
    menu << '4) BACK'
    @menus['SELECT PRODUCT'] = menu
  end

  def get_current_menu
    get_menu current_menu
  end

  def get_menu(menu)
    if menu == 'SELECT PRODUCT'
      generate_product_menu
    end
    menu_display = "-- #{menu} --\n\n"
    @menus[menu].each do |choice|
      menu_display += "#{choice}\n"
    end
    menu_display
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
      display = format_to_money get_price(item_selected)
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
    credits_to_return = coin_return
    @coin_return = 0
    "You get back #{credits_to_return} credits!"
  end

  def add_to_inventory(item)
    if @inventory.has_key? item
      @inventory[item] += 1
    else
      @inventory[item] = 1
    end
  end

  def check_stock(item)
    if @inventory.has_key? item
      if @inventory[item] > 0
        return true
      end
    end
    false
  end

  def select_item(item)
    unless check_stock item
      @item_sold_out = true
      return
    end

    @item_selected = item
    if credits < get_price(item)
      @insufficient_funds = true
      'Not enough credits!'
    else
      @product_bin.push item
      @inventory[item] -= 1
      @coin_return += (credits - get_price(item))
      @credits = 0
      "#{item} has been placed in the bin!"
    end
  end

  def check_product_bin
    product_bin
  end

  def pick_up_item
    if @product_bin.empty?
      return 'You can not pick up nothing!'
    end
    "You have picked up #{@product_bin.pop}!"
  end

  def return_coins
    @coin_return += credits
    @credits = 0
    'All coins returned!'
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