def code_word(numbers):
    return "".join(chr(n - 7) for n in numbers)

print("CODE WORD 6:", code_word([87, 89, 86, 81, 76, 74, 91, 86, 89]))
print()
print("CODE WORD 6 was:", code_word([87, 89, 86, 81, 76, 74, 91, 86, 89]))
