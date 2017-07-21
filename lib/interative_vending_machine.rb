require_relative 'vending_machine'

vm = VendingMachine.new
vm.add_to_inventory 'Pop'
vm.add_to_inventory 'Chips'
vm.add_to_inventory 'Candy'

puts '** Vending Machine is initially stocked with one of each item! **'
puts

while vm.is_running? do

  puts '-------------'
  puts vm.get_display
  puts '-------------'
  puts

  puts vm.get_current_menu

  puts
  puts 'ENTER CHOICE? '
  input = STDIN.gets.chomp.to_i
  puts vm.process_input input
end
