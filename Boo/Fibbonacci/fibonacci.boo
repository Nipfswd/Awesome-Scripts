# Generate the first N Fibonacci numbers

def fibonacci(n as int):
    a = 0
    b = 1
    for i in range(n):
        print a
        temp = a
        a = b
        b = temp + b

print "Enter how many Fibonacci numbers to generate:"
n = int(Console.ReadLine())
fibonacci(n)
