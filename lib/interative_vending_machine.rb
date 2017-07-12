require_relative 'vending_machine'

at_vending_machine = true

vm = VendingMachine.new

while at_vending_machine do
  input = STDIN.gets.chomp

  puts input
end
