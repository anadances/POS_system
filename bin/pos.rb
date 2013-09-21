require 'active_record'
require 'pg'
require 'rake'
require 'rspec'
require 'active_record_migrations'
require 'shoulda-matchers'
require 'pry'

require '../lib/purchase'
require '../lib/sale'
require '../lib/product'
require '../lib/cashier'
require '../lib/grocery'
require '../lib/alcohol'
require '../lib/household'

database_configurations = YAML::load(File.open('../db/config.yml'))
development_configuration = database_configurations["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "\e[H\e[2J"
  puts "Welcome to the Point of Sale system"
  gets
  menu
end

def menu
  puts "\e[H\e[2J"
  choice = nil
  until choice == 'x'
    puts "Are you a [C]ashier or [O]wner?"
    puts "Press 'X' to exit."
    choice = gets.chomp.downcase.strip
    case choice
    when 'c'
      cashier_menu
    when 'o'
      owner_menu
    when 'x'
      puts 'good-bye'
    else
      puts 'I did not understand.'
    end
  end
end

def owner_menu
  puts "\e[H\e[2J"
  choice = nil
  until choice == 'x'
  puts "[A]dd a cashier, [D]elete a cashier or [V]iew all cashiers." 
  puts "Add a [p]roduct or [E]dit a product, [s]ee all products"
    choice = gets.chomp.downcase.strip
    case choice
    when 'a'
      add_cashier
    when 'd'
      delete_cashier
    when 'v'
      Cashier.all.each_with_index {|cashier, index| puts "#{index + 1}. #{cashier.name}"}
    when 'p'
      add_product
    when 'e'
      edit_product 
    when 's'
      Product.all.each_with_index {|product, index| puts "#{index + 1}. #{product.name}  $#{product.price}   #{product.type}"}
    when 'x'
      # main menu
    else      
      puts "I did not understand."
    end
  end    
end

def cashier_menu
  puts "\e[H\e[2J"
  puts "What is your name?"
  name = gets.chomp.downcase.capitalize
  if Cashier.exists?(name: name)
    cashier = Cashier.where(name: name).first
    puts "Welcome #{cashier.name}!"
  else
    puts "#{name} is not a cashier in our system."
    cashier_menu
  end
  choice = nil
  until choice == 'x'
    puts "Hi, #{cashier.name}."
    puts "Start a [S]ale."
    choice = gets.chomp
    case choice 
    when 's'
      new_sale(cashier)
    when 'x'
      # return to main
    else
      puts "I don't understand."
    end
  end
end

def add_cashier
  puts "What is the name of the cashier?"
  choice = gets.chomp.strip.downcase.capitalize
  cashier = Cashier.create(name: choice)
  puts "#{cashier.name} has been added." 
end

def delete_cashier
  Cashier.all.each_with_index {|cashier, index| puts "#{index + 1}. #{cashier.name}"}
  puts "Which cashier do you want to delete?"  
  number = gets.chomp.to_i
  Cashier.all[number-1].delete
  puts "Cashier deleted."
end

def add_product
  puts "What is the product name?"
  name = gets.chomp
  puts "What is the product price?"
  price = gets.chomp
  type = nil
  until type == 'a' || type == 'g' || type == 'h'
    puts "Is it [a]lcohol, [g]roceries or [h]ousehold?"
    type = gets.chomp
    case type
    when 'a'
      product = Alcohol.create(name: name, price: price)
    when 'g'
      product = Grocery.create(name: name, price: price)
    when 'h'
      product = Household.create(name: name, price: price)
    else 
      puts "That is not a valid input."
    end
  end
  puts "#{product.name} has been added to the system."
end

def edit_product
  Product.all.each_with_index {|product, index| puts "#{index + 1}. #{product.name}"}
  puts "Which product do you want to edit? Or press x to return to the owner menu."
  choice = gets.chomp.to_i
  if choice == 0
    owner_menu
  else                                                                                                 
    product = Product.all[choice - 1]
    puts "Do you want to [e]dit or [d]elete #{product.name}?"
    input = gets.chomp
    if input == 'e'  
      puts "What is the new name of #{product.name}?"
      new_name = gets.chomp
      product.update(name: new_name)
      puts "Product has been edited."
      edit_product
    elsif input == 'd'
      product.delete
      puts "Product has been deleted."
      edit_product
    else  
    puts "I did not understand."
    edit_product
    end
  end
end


def new_sale(cashier)
  sale = Sale.create(cashier_id: cashier.id)
  choice = nil
  until choice == 'c'
    Product.all.each_with_index {|product, index| puts "#{index + 1}. #{product.name}"}
    puts "Choose a product to ring up:"
    item_number = gets.chomp.to_i
    product = Product.all[item_number - 1]
    puts "How many #{product.name}?"
    item_amount = gets.chomp.to_i
    purchase = Purchase.create(product_id: product.id, quantity: item_amount, sale_id: sale.id)
    puts "You purchased #{purchase.quantity} #{product.name}s"
    puts "[A]dd another product or [c]omplete sale."
    choice = gets.chomp
  end

  # total = sale.purchases
  # total
  #     binding.pry
  # sale.purchases.reduce do |purchase|

  #   purchase.products.price * purchase.quantity
  # end
  # puts "#{total}" 
end

  

# def new_sale
#   puts ""
# end
welcome

















