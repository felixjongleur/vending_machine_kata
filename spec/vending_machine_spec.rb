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
        expect(@vm.check_coin_return).to eql 0
      end
    end
  end

  describe '.check_product_bin' do
    context 'when no product has been purchased' do
      it 'returns nothing' do
        expect(@vm.check_product_bin).to eql nil
      end
    end
  end

  describe '.return_coins' do
    context 'when the return coins button is pressed' do
      it 'places any inserted coins into the coin return and resets the display' do
        @vm.insert_coin Coin::NICKEL
        @vm.insert_coin Coin::DIME
        @vm.return_coins
        expect(@vm.check_coin_return).to eql 15
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
        expect(@vm.check_coin_return).to eql 1
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
end