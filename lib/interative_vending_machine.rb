require_relative 'vending_machine'

at_vending_machine = true

vm = VendingMachine.new

while at_vending_machine do

  puts '-------------'
  puts vm.get_display
  puts '-------------'
  puts

  puts vm.get_menu 'MAIN'

  puts
  puts 'ENTER CHOICE? '
  input = STDIN.gets.chomp
end
