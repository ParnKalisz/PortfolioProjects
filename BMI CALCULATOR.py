#This is a BMI Calculator

Weight = float(input("Please, provide your weight in kilos: "))
Height = float(input("Please, provide your height in meters: "))
print(f'Your weight is: {Weight} and your height is: {Height}.')
BMI = Weight / Height ** 2
print(f'Your BMI is: {BMI}')

if BMI < 16.0:
    print("You are underweight!")
elif 18.5 <= BMI <= 24.9:
    print("You're healthy!")
elif 25.0 <= BMI <= 34.9:
    print("You're over weight!")
elif 30 <= BMI <= 34.9:
    print("You're severely over weight!")
else:
    print("You're OBESE!")
