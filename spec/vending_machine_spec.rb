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
end
