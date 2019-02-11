# validate input units value ...
module ValidateInput
  def validate_input(units, user_cat)
    if (user_cat.eql?('RGP') || user_cat.eql?('NReGP')) && units <= 15
      true
    elsif (user_cat.eql?('LTMD1') || user_cat.eql?('LTMD2')) && units >= 15
      true
    elsif user_cat.eql?('TMP') && units < 100
      true
    elsif (user_cat.eql?('HTMD1') || user_cat.eql?('HTMD3')) && units >= 100
      true
    else
      puts "\nCategory\t\tUnits\n\n"
      puts "RGP\t\t<=15\n"
      puts "NReGP\t\t<=15\n"
      puts "LTMD1\t\t>=15\n"
      puts "LTMD2\t\t>=15\n"
      puts "HTMD1\t\t>=100\n"
      puts "HTMD3\t\t>=100\n"
      false
    end
  end
end
