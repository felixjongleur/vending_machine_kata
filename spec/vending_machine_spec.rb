require 'spec_helper'

describe 'VendingMachine' do

  describe '.get_display' do
    context 'when no coins have been inserted' do
      it 'returns INSERT COINS' do
        @vm = VendingMachine.new
        expect(@vm.get_display).to eql 'INSERT COINS'
      end
    end
  end

  describe '.valid_coin' do
    context 'when it is a valid coin' do
      it 'returns TRUE' do
        @vm = VendingMachine.new
        expect(@vm.valid_coin?(Coin::NICKEL)).to be true
      end
    end

    context 'when it is an invalid coin' do
      it 'returns FALSE' do
        @vm = VendingMachine.new
        expect(@vm.valid_coin?(Coin::PENNY)).to be false
      end
    end
  end

end
