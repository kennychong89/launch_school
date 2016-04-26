# Simple Mortgage Calculator
# Kenny Chong
# 4/24/2016

def convert_apr_to_monthly_interest_rate(apr)
  # convert apr (which should in percentage) to decimal format
  apr_in_decimal_format = convert_percent_to_decimal(apr)

  # divide apr_in_decimal_format by 12.0 to get the monthly interest
  apr_in_decimal_format / 12.0
end

def convert_loan_duration_in_years_to_months(loan_duration_years)
  loan_duration_years * 12
end

def convert_percent_to_decimal(percent_value)
  percent_value.to_f / 100.0
end

def calculate_monthly_payment(loan_amount, monthly_interest_rate, loan_duration_months)
  monthly_payment = (monthly_interest_rate * loan_amount * (1 + monthly_interest_rate)**loan_duration_months) /
                    ((1 + monthly_interest_rate)**loan_duration_months - 1)

  monthly_payment.round(2)
end

def prompt(message)
  puts("=> #{message}")
end

def valid_number?(number)
  /\d/.match(number) && /^-?\d*\.?\d*$/.match(number)
end

def negative_number?(number)
  number.to_f < 0.0
end

def more_than_one_million_dollars?(loan_amount)
  one_million_dollars = 10**6

  loan_amount.to_f > one_million_dollars.to_f
end

def more_than_50_years?(loan_duration)
  loan_duration.to_i > 50
end

def ask_user_for_apr
  apr = ''
  loop do
    prompt("Please enter the annual percentage rate (APR) (ex: 5 for 5%):")
    apr = gets.chomp

    break unless !valid_number?(apr) || negative_number?(apr)
    prompt("Invalid annual percentage rate: must be a non-negative number")
  end

  # return apr in float representation rounded to 3 decimal places
  apr.to_f.round(3)
end

def ask_user_for_loan_amount
  loan_amount = ''

  loop do
    prompt("Please enter the loan amount (principal). Max loan is 1 million dollars:")
    loan_amount = gets.chomp

    break unless !valid_number?(loan_amount) || !negative_number?(loan_amount) || more_than_one_million_dollars?(loan_amount)
    prompt("Invalid loan amount: \n - loan must be a non-negative number \n - loan cannot exceed 1 million dollars \n")
  end
  # return loan amount in float representation rounded to 2 decimal places
  loan_amount.to_f.round(2)
end

def ask_user_for_loan_duration
  loan_duration = ''

  loop do
    prompt("Please enter the duration of the loan in years. Max duration is 50 years:")
    loan_duration = gets.chomp

    break unless !valid_number?(loan_duration) || negative_number?(loan_duration) || more_than_50_years?(loan_duration)
    prompt("Invalid loan duration: must be a non-negative number")
  end

  # return loan duration in integer representation
  loan_duration.to_i
end

def ask_user_to_continue?
  answer = ''
  loop do
    prompt("Do you want to calculate another mortgage?\n (type 'y' to calculate again or 'n' to exit)")
    answer = gets.chomp
  
    break unless !answer.downcase.start_with?('y', 'n')
    prompt("Please type 'y' to start over or 'n' finish.")
  end

  answer
end

def start_calculator
  prompt("Let's calculate your monthly payment for your mortgages!")
  loop do
    apr = ask_user_for_apr
    loan_amount = ask_user_for_loan_amount
    loan_duration_years = ask_user_for_loan_duration

    monthly_interest_rate = convert_apr_to_monthly_interest_rate(apr)
    loan_duration_months = convert_loan_duration_in_years_to_months(loan_duration_years)
    monthly_payment = calculate_monthly_payment(loan_amount, monthly_interest_rate, loan_duration_months)

    prompt("Your monthly payment is: #{monthly_payment}")
    continue = ask_user_to_continue?

    break unless continue == 'y'
  end
  prompt("Thank you for trying the calculator.")
  # for fun
  # tidbit = <<-MSG
  # Today's Tidbit:
  # --A fixed mortgage means that the interest rate is locked for the duration of the mortgage's lifespan.
  # --An adjustable mortgage means the interest rate may go up and down. There are many factors contributing to the change, such as the housing economy.
  # MSG
  # puts tidbit
end

# start here
start_calculator

# Possible Test Cases:
# APR: 5%
# Loan amount: 1000000
# Loan term: 20 years
# Monthly payment = $6,599.56

# TESTING AREA #
# puts "3 is a valid number? " + valid_number?("3").to_s
# puts "1.23 is a valid number? " + valid_number?("1.23").to_s
# puts "1.a2 is a valid number? " + valid_number?("1.a2").to_s
# puts "-1.21 is a valid number? " + valid_number?("-1.21").to_s
# puts "-1.23 is a negative number? " + negative_number?("-1.23").to_s
# puts "1.0 is a negative number? " + negative_number?("1.0").to_s

# puts ask_user_for_apr
# puts ask_user_for_loan_amount
# puts ask_user_for_loan_duration
# puts convert_apr_to_monthly_interest_rate(24)
# puts convert_loan_duration_in_years_to_months(2)
# puts calculate_monthly_payment(250000.00, (4.0 / 100) / 12, 360)
