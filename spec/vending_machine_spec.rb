require 'spec_helper'

describe 'VendingMachine' do

  before(:each) do
    @vm = VendingMachine.new
  end

  describe '.get_display' do
    context 'when no coins have been inserted' do
      it 'returns INSERT COINS' do
        expect(@vm.get_display).to eql 'INSERT COINS'
      end
    end

    context 'when coins have been inserted' do
      it 'returns the current value of credits' do
        @vm.insert_coin Coin::NICKEL
        expect(@vm.get_display).to eql '$0.05'
        @vm.insert_coin Coin::DIME
        expect(@vm.get_display).to eql '$0.15'
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::DIME
        expect(@vm.get_display).to eql '$1.00'
        @vm.insert_coin Coin::QUARTER
        expect(@vm.get_display).to eql '$1.25'
      end
    end

    context 'when an item is selected with no credits' do
      it 'the display shows the items PRICE once, then INSERT COINS' do
        @vm.add_to_inventory 'Pop'
        @vm.select_item 'Pop'
        expect(@vm.get_display).to eql '$1.00'
        expect(@vm.get_display).to eql 'INSERT COINS'
        @vm.add_to_inventory 'Chips'
        @vm.select_item 'Chips'
        expect(@vm.get_display).to eql '$0.50'
        expect(@vm.get_display).to eql 'INSERT COINS'
        @vm.add_to_inventory 'Candy'
        @vm.select_item 'Candy'
        expect(@vm.get_display).to eql '$0.65'
        expect(@vm.get_display).to eql 'INSERT COINS'
      end
    end

    context 'when an item is selected with some, but not enough credits' do
      it 'the display shows the items PRICE once, then the current value of credits' do
        @vm.insert_coin Coin::QUARTER
        @vm.add_to_inventory 'Chips'
        @vm.select_item 'Chips'
        expect(@vm.get_display).to eql '$0.50'
        expect(@vm.get_display).to eql '$0.25'
      end
    end

    context 'when an item is selected and there is sufficient funds' do
      it 'the display says THANK YOU, only the next time its checked' do
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.add_to_inventory 'Chips'
        @vm.select_item 'Chips'
        expect(@vm.get_display).to eql 'THANK YOU'
        expect(@vm.get_display).to eql 'INSERT COINS'
      end
    end

    context 'when no credits and an item is selected and there are non of it left' do
      it 'the display says SOLD OUT, then subsequently INSERT COINS' do
        @vm.select_item 'Chips'
        expect(@vm.get_display).to eql 'SOLD OUT'
        expect(@vm.get_display).to eql 'INSERT COINS'
      end
    end
  end

  describe '.check_stock' do
    context 'when the item is not in stock' do
      it 'returns a value of false' do
        expect(@vm.check_stock 'Candy').to be false
      end
    end

    context 'when the item is in stock' do
      it 'returns a value of true' do
        @vm.add_to_inventory 'Candy'
        expect(@vm.check_stock 'Candy').to be true
      end
    end
  end

  describe '.add_to_inventory' do
    context 'when an item is added to the inventory' do
      it 'adds it to the inventory' do
        @vm.add_to_inventory 'Candy'
        expect(@vm.inventory.has_key? 'Candy').to be true
      end
    end

    context 'when multiple of the same item is added to the inventory' do
      it 'adds both to the inventory' do
        @vm.add_to_inventory 'Candy'
        @vm.add_to_inventory 'Candy'
        expect(@vm.inventory['Candy']).to eq 2
      end
    end

    context 'when multiple of different items are added to the inventory' do
      it 'adds all items to the inventory' do
        @vm.add_to_inventory 'Candy'
        @vm.add_to_inventory 'Candy'
        @vm.add_to_inventory 'Pop'
        @vm.add_to_inventory 'Pop'
        expect(@vm.inventory['Candy']).to eq 2
        expect(@vm.inventory['Pop']).to eq 2
      end
    end
  end

  describe '.get_credits' do
    context 'when no coins have been inserted' do
      it 'returns a value of 0' do
        expect(@vm.get_credits).to eql 0
      end
    end
  end

  describe '.check_coin_return' do
    context 'when no coins have been returned' do
      it 'returns a value of 0' do
        expect(@vm.check_coin_return).to eql 'You get back 0 credits!'
      end
    end
  end

  describe '.return_coins' do
    context 'when the return coins button is pressed' do
      it 'places any inserted coins into the coin return and resets the display' do
        @vm.insert_coin Coin::NICKEL
        @vm.insert_coin Coin::DIME
        @vm.return_coins
        expect(@vm.check_coin_return).to eql 'You get back 15 credits!'
        expect(@vm.get_credits).to eql 0
      end
    end
  end

  describe '.get_value' do
    context 'when a coin is examined' do
      it 'returns the coins value' do
        expect(@vm.get_value(Coin::PENNY)).to eql 1
        expect(@vm.get_value(Coin::NICKEL)).to eql 5
        expect(@vm.get_value(Coin::DIME)).to eql 10
        expect(@vm.get_value(Coin::QUARTER)).to eql 25
      end
    end
  end

  describe '.insert_coin' do
    context 'when a valid coin has been inserted' do
      it 'adds its value to the current credits' do
        @vm.insert_coin Coin::NICKEL
        expect(@vm.get_credits).to eql 5
        @vm.insert_coin Coin::DIME
        expect(@vm.get_credits).to eql 15
        @vm.insert_coin Coin::QUARTER
        expect(@vm.get_credits).to eql 40
      end
    end

    context 'when an invalid coin has been inserted' do
      it 'does not add its value to the current credits and it is placed in the coin return' do
        @vm.insert_coin Coin::PENNY
        expect(@vm.get_credits).to eql 0
        expect(@vm.check_coin_return).to eql 'You get back 1 credits!'
      end
    end
  end

  describe '.valid_coin' do
    context 'when it is a valid coin' do
      it 'returns TRUE' do
        expect(@vm.valid_coin?(Coin::NICKEL)).to be true
        expect(@vm.valid_coin?(Coin::DIME)).to be true
        expect(@vm.valid_coin?(Coin::QUARTER)).to be true
      end
    end

    context 'when it is an invalid coin' do
      it 'returns FALSE' do
        expect(@vm.valid_coin?(Coin::PENNY)).to be false
      end
    end
  end

  describe '.check_product_bin' do
    context 'when no product has been purchased' do
      it 'returns nothing' do
        expect(@vm.check_product_bin).to eql []
      end
    end
  end

  describe '.select_item' do
    context 'when an item is selected' do
      it 'is placed in the bin, current credits are set to 0, and inventory is reduced' do
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.add_to_inventory 'Chips'
        @vm.select_item 'Chips'
        expect(@vm.check_product_bin).to eql ['Chips']
        expect(@vm.check_stock 'Chips').to eql false
        expect(@vm.get_credits).to eql 0
      end
    end

    context 'when multiple items have been selected' do
      it 'they are all placed in the bin' do
        @vm.add_to_inventory 'Chips'
        @vm.add_to_inventory 'Pop'
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.select_item 'Pop'
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.select_item 'Chips'
        expect(@vm.check_product_bin).to eql %w(Pop Chips)
      end
    end

    context 'when an item is selected' do
      it 'any remainder credits are placed in the coin return' do
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.insert_coin Coin::QUARTER
        @vm.add_to_inventory 'Chips'
        @vm.select_item 'Chips'
        expect(@vm.check_coin_return).to eql 'You get back 25 credits!'
      end
    end
  end

  describe '.pick_up_item' do
    context 'when an item is in the bin' do
      it 'says it has been picked up' do
        @vm.product_bin = ['Chips']
        expect(@vm.pick_up_item).to eq 'You have picked up Chips!'
      end
    end

    context 'when multiple items are in the bin' do
      it ' says they have been picked up' do
        @vm.product_bin = %w(Pop Chips)
        expect(@vm.pick_up_item).to eq 'You have picked up Chips!'
        expect(@vm.pick_up_item).to eq 'You have picked up Pop!'
      end
    end

    context 'when no items are in the bin' do
      it 'says you can not pick up nothing!' do
        expect(@vm.pick_up_item).to eq 'You can not pick up nothing!'
      end
    end
  end

  describe '.get_menu' do
    context 'when the main menu is called' do
      it 'returns appropriately' do
        expect(@vm.get_menu 'MAIN').to eq "-- MAIN --\n\n1) INSERT COIN\n2) SELECT ITEM\n3) TAKE FROM BIN\n4) RETURN COINS\n5) TAKE FROM COIN RETURN\n6) TURN OFF\n"
      end
    end

    context 'when the insert coin menu is called' do
      it 'returns appropriately' do
        expect(@vm.get_menu 'INSERT COIN').to eq "-- INSERT COIN --\n\n1) PENNY\n2) NICKEL\n3) DIME\n4) QUARTER\n5) BACK\n"
      end
    end

    context 'when the select product menu is called, and no products are available' do
      it 'returns appropriately' do
        expect(@vm.get_menu 'SELECT PRODUCT').to eq "-- SELECT PRODUCT --\n\nNO PRODUCTS AVAILABLE!\n4) BACK\n"
      end
    end

    context 'when the select product menu is called, and products are available' do
      it 'returns appropriately' do
        @vm.add_to_inventory 'Chips'
        @vm.add_to_inventory 'Pop'
        @vm.add_to_inventory 'Candy'
        expect(@vm.get_menu 'SELECT PRODUCT').to eq "-- SELECT PRODUCT --\n\n1) CHIPS\n2) POP\n3) CANDY\n4) BACK\n"
      end
    end
  end

  describe '.get_current_menu' do
    context 'when the vending machine is first turned on' do
      it 'returns the main menu' do
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end
  end

  describe '.process_input for the main menu' do
    context 'when on the main menu and insert coins is selected' do
      it 'sets the current menu to insert coin' do
        @vm.process_input 1
        expect(@vm.current_menu).to eq 'INSERT COIN'
      end
    end

    context 'when on the main menu and select product is selected' do
      it 'sets the current menu to select product' do
        @vm.process_input 2
        expect(@vm.current_menu).to eq 'SELECT PRODUCT'
      end
    end

    context 'when on the main menu and get from bin is called with nothing in it' do
      it 'returns an appropriate message and stays on the main menu' do
        expect(@vm.process_input 3).to eq 'You can not pick up nothing!'
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the main menu and get from bin is called with something in it' do
      it 'returns an appropriate message and stays on the main menu' do
        @vm.product_bin = %w(Pop Chips)
        expect(@vm.process_input 3).to eq 'You have picked up Chips!'
        expect(@vm.process_input 3).to eq 'You have picked up Pop!'
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the main menu and get from coin return is called with nothing in it' do
      it 'returns an appropriate message and stays on the main menu' do
        expect(@vm.process_input 5).to eq 'You get back 0 credits!'
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the main menu and get from coin return is called with coins in it' do
      it 'returns an appropriate message and stays on the main menu' do
        @vm.insert_coin Coin::NICKEL
        @vm.return_coins
        expect(@vm.process_input 5).to eq 'You get back 5 credits!'
        @vm.insert_coin Coin::DIME
        @vm.return_coins
        expect(@vm.process_input 5).to eq 'You get back 10 credits!'
        @vm.insert_coin Coin::QUARTER
        @vm.return_coins
        expect(@vm.process_input 5).to eq 'You get back 25 credits!'
        expect(@vm.process_input 5).to eq 'You get back 0 credits!'
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the main menu and return coins is called ' do
      it 'returns an appropriate message and stays on the main menu' do
        expect(@vm.process_input 5).to eq 'You get back 0 credits!'
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the main menu and turn off is selected' do
      it 'turns off' do
        @vm.process_input 6
        expect(@vm.is_running?).to be false
      end
    end
  end

  describe '.process_input for the insert coin menu' do
    context 'when on the insert coin menu and back is selected' do
      it 'goes back to the main menu' do
        @vm.process_input 1
        @vm.process_input 5
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the insert coin menu and penny is selected' do
      it 'places the coin in the coin return' do
        @vm.process_input 1
        expect(@vm.process_input 1).to eq 'Pennies are not accepted!'
        expect(@vm.check_coin_return).to eq 'You get back 1 credits!'
      end
    end

    context 'when on the insert coin menu and a non penny is selected' do
      it 'adds appropriately to the available credits' do
        @vm.process_input 1
        expect(@vm.process_input 2).to eq 'A nickel has been inserted!'
        expect(@vm.get_credits).to eq 5
        expect(@vm.process_input 3).to eq 'A dime has been inserted!'
        expect(@vm.get_credits).to eq 15
        expect(@vm.process_input 4).to eq 'A quarter has been inserted!'
        expect(@vm.get_credits).to eq 40
      end
    end
  end

  describe '.process_input for the select product menu' do
    context 'when on the select product menu and back is selected' do
      it 'goes back to the main menu' do
        @vm.process_input 2
        @vm.process_input 4
        expect(@vm.current_menu).to eq 'MAIN'
      end
    end

    context 'when on the select product menu and an item is selected without enough money' do
      it 'returns an appropriate message' do
        @vm.add_to_inventory 'Pop'
        @vm.process_input 2
        expect(@vm.process_input 1).to eq 'Not enough credits!'
        expect(@vm.current_menu).to eq 'SELECT PRODUCT'
      end
    end

    context 'when on the select product menu and an item is selected with enough money' do
      it 'returns an appropriate message and places the item in the bin' do
        @vm.add_to_inventory 'Pop'
        @vm.credits = 100
        @vm.process_input 2
        expect(@vm.process_input 1).to eq 'Pop has been placed in the bin!'
        expect(@vm.current_menu).to eq 'SELECT PRODUCT'
      end
    end
  end

  describe '.is_running?' do
    context 'when the vending machine is created' do
      it 'is turned on' do
        expect(@vm.is_running?).to be true
      end
    end
  end
end