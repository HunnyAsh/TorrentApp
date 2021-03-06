# for calculating bill for torrent power...
module Calculations
  def bill_calculation(user_cat, units, _phase)
    # billing
    bill = case user_cat
           when 'RGP'
             calculate_bill_rgp(units, phase)
           when 'BPL'
             calculate_bill_bpl(units)
           when 'GLP'
             calculate_bill_glp(units, phase)
           when 'NReGP'
             calculate_bill_nonrgp(units)
           when 'LTP'
             calculate_bill_ltp(units)
           when 'LTMD1'
             calculate_bill_lmtd1(units)
           when 'LTMD2'
             calculate_bill_lmtd2(units)
           when 'SL'
             calculate_bill_sl(units)
           when 'TMP'
             calculate_bill_tmp(units)
           when 'HTMD1'
             calculate_bill_htmd1(units)
           when 'HTMD2'
             calculate_bill_htmd2(units)
           when 'HTMD3'
             calculate_bill_htmd3(units)
           end
    bill
  end

  # RGP Category methods........
  def calculate_bill_rgp(units, _phase)
    amt = 0
    amt += get_appropriate_units_rgp(units)
    amt += phase.eql?(1) ? 25 * 2 : 65 * 2
    amt * 60
  end

  def get_appropriate_units_rgp(units)
    res = 0
    kwh = units * 24
    res += get_first_50(kwh,320)
    kwh -= 50 if kwh - 50 > 0
    res += get_next_150(kwh)
    kwh -= 150 if kwh - 150 > 0
    res += remaining_units(kwh, 420)
    res
  end

  def get_first_50(kwh,rate)
    kwh <= 50 ? kwh * rate / 100.0 : 50 * rate / 100.0
  end

  def get_next_150(kwh)
    res <= 150 ? kwh * 390 / 100.0 : 150 * 390 / 100.0
  end

  def remaining_units(kwh, rate)
    kwh > 0 ? kwh * rate / 100.0 : res
  end

  # RGP BPL sub category methods
  def calculate_bill_bpl(units)
    amt = 0
    amt += get_appropriate_units_bpl(units) * 60
    amt += 5 * 2
    amt
  end

  def get_appropriate_units_bpl(units)
    res = 0
    kwh = units * 24
    res += get_first_30(kwh,150)
    kwh -= 30 if kwh > 0
    res += get_next_20(kwh)
    kwh -= 20 if kwh > 0
    res += get_next_150(kwh)
    kwh -= 150 if kwh > 0
    res += remaining_units(kwh, 490)
    res
  end

  def get_first_30(kwh,rate)
    kwh <= 30 ? kwh * rate / 100.0 : 30 * rate / 100.0
  end

  def get_next_20(kwh)
    kwh <= 20 ? kwh * 320 / 100.0 : 20 * 320 / 100.0
  end

  # GLP methods
  def calculate_bill_glp(units, _phase)
    amt = 0
    amt += get_appropriate_units_glp(units) * 60
    amt += phase.eql?(1) ? 30 * 2 : 70 * 2
    amt
  end

  def get_appropriate_units_glp(units)
    res = 0
    kwh = units * 24
    res += kwh <= 200 ? kwh * 410 / 100.0 : 200 * 410 / 100.0
    kwh -= 200 if kwh - 200 > 0
    res += remaining_units(kwh,480)
    res
  end

  # Non Grp methods
  def calculate_bill_nonrgp(units)
    amt = 0
    amt += (units * 450) / 100.0
    amt += fixed_charges_nonrgp
    amt
  end

  def fixed_charges_nonrgp
    if units <= 5
      70 * 2
    elsif units.between?(5, 15)
      90 * 2
    end
  end

  # LTP methods
  def calculate_bill_ltp(units)
    amt = 0
    amt += (units * 330 * 24 * 60 / 100.0) + ((units / 0.745699872) * 10) # 1kW = 0.745699872 bhp
    amt
  end

  # ltmd1 methods
  def calculate_bill_lmtd1(units)
    amt = 0
    amt += get_appropriate_units_lmtd1(units)
    amt += fixed_charges(units)
    amt += power_factor
    amt
  end

  def get_appropriate_units_lmtd1(_units)
    units <= 50 ? 455 * units * 24 / 100.0 : 470 * units * 24 / 100.0
  end

  def fixed_charges(units)
    res = 0
    kwh = units * 24
    res += get_first_50(kwh,150)
    kwh -= 50 if kwh - 50 > 0
    res += get_first_30(kwh,185)
    kwh -= 30 if kwh - 30 > 0
    res += remaining_units(kwh,245)
    res
  end

  def power_factor
    puts 'Enter power factor...(in 90-95%)'
    pf = gets.to_i
    case pf
    when 90..95
      0.15 / 100 * units
    when pf > 95
      0.27 / 100 * units
    when pf < 90
      3 / 100 * units
    end
  end

  # ltmd2 methods
  def calculate_bill_lmtd2(units)
    amt = 0
    amt += units < 50 ? (470 * units / 100.0) : (490 * units / 100.0)
    amt *= 24 * 60
    amt += fixed_charges_lmtd2(units)
    amt += power_factor
    amt
  end

  def fixed_charges_lmtd2(units)
    res = 0
    kwh = units * 24
    res += get_first_50(kwh,175)
    kwh -= 50 if kwh - 50 > 0
    res += get_first_30(kwh,230)
    kwh -= 30 if kwh - 30 > 0
    res += remaining_units(kwh,300)
    res
  end

  # Street Light Methods
  def calculate_bill_sl(units)
    420 * units * 24 * 60 / 100.0
  end

  # TMp methods
  def calculate_bill_tmp(units)
    amt = 0
    amt += 25 * units * 60
    amt += 500 * units * 24 / 100.0
    amt
  end

  # HTMD1 Calculation methods
  def calculate_bill_htmd1(units)
    amt = 0
    amt += get_appropriate_units_htmd1(units) + fixed_charges_htmd1(units)
    amt += power_factor + tou_charge_htmd1(units) + 30 * units / 100.0
    amt
  end

  def get_appropriate_units_htmd1(units)
    res = 0
    kwh = units * 24
    res += kwh <= 400 ? kwh * 445 / 100.0 : 400 * 445 / 100.0
    kwh -= 400 if kwh - 400 > 0
    res += kwh > 0 ? kwh * 435 / 100.0 : res
    res
  end

  def fixed_charges_htmd1(units)
    if units <= 1000
      260 * units
    elsif units > 1000
      335 * units
    else
      385 * units
    end
  end

  def tou_charge_htmd1(units)
    if units <= 300
      80 * units * 24 * 60
    else
      100 * units * 24 * 60
    end
  end

  # HTMD2 calculations methods
  def calculate_bill_htmd2(units)
    amt = 0
    # haven't considered here the billing demand
    amt += units * 400 / 100.0 + 225 * units + power_factor + 60 * units / 100.0 + 30 * units / 100.0
    amt
  end

  # HTMD3 calculations methods
  def calculate_bill_htmd3(units)
    amt = 0
    amt += (695 * units * 24 * 60 / 100.0) + (25 * units * 60) + power_factor
    amt += (60 * units * 24 * 60 / 100.0)
    amt
  end
end
