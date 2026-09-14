from sympy import symbols, diff
print("x^y")
h = symbols('h')
print("Enter the value of x:")
x = int(input())
print("Enter the value of y:")
y = int(input())
print(str((x+h) ** y))
