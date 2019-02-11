require_relative 'hash_module'
require_relative 'calculationsModule'
require_relative 'validateInput'
# # tariff Calculation for torrent app
# USer class inherited to access the values initialized in tariff class
class User
  include HashModule
  attr_accessor :phase
  def print_hash
    categories = get_categories
    categories[0].each { |key, value| puts "#{key} #{value}\n" }
  end

  def get_user_cat(category)
    categories = get_categories
    cat = categories[0].key?(category) ? categories[0][category] : 'invalid input'
    if cat.include?('RGP')
      puts "Select sub category : \n1.RGP\n2.BPL\n"
      sub_cat = gets.to_i
      cat = categories[1].key?(sub_cat) ? categories[1][sub_cat] : 'invalid input'
    end
    cat
  end

  def phase_get
    puts "Select phase \n1.Single Phase\n2. Three Phase\n"
    phase = gets.to_i
    phase
  end
end
# calculating bill for a particular user...
class Bill < User
  attr_accessor :category, :units
  include Calculations
  extend ValidateInput
  def initialize(user_cat, units)
    @category = user_cat
    @units = units
    @phase = phase_get if user_cat.include?('RGP') || user_cat.include?('GLP')
    @phase = 0 unless user_cat.include?('RGP') || user_cat.include?('GLP')
  end

  def bill_calculate
    bill_calculation(category, units, phase)
  end

  def self.validate(units, cat_name)
    validate_input(units, cat_name)
  end
end
# Menu for selecting category for bill Calculation
puts "\n\t-----Select your Category for calculating tariff-----\n\n"
User.new.print_hash
puts "\n\t--------------------------------------------------------\n"
puts 'Select no. in menu for your category....'
cat_choice = gets.to_i
user_cat = User.new.get_user_cat(cat_choice)
puts user_cat
units = 0
unless user_cat.eql?('invalid input')
  # units in electricity bill are measured in kWs
  validate_cats = %w[RGP NReGP LTMD1 LTMD2 TMP HTMD1 HTMD3]
  if validate_cats.include? user_cat
    loop do
      puts 'Enter units used ...(in kW)'
      units = gets.to_i
      break if Bill.validate(units, user_cat)
    end
  else
    puts 'Enter units used ...(in kW)'
    units = gets.to_i
  end
  billing_amt = Bill.new(user_cat, units).bill_calculate
  p "Amount to be paid...= Rs. #{billing_amt}"
end
