using System;

class Calculator
{
    static void Main()
    {
        Console.Write("Enter first number: ");
        if (!double.TryParse(Console.ReadLine(), out double num1))
        {
            Console.WriteLine("Invalid number.");
            return;
        }

        Console.Write("Enter an operator (+, -, *, /): ");
        char op = Console.ReadKey().KeyChar;
        Console.WriteLine();

        Console.Write("Enter second number: ");
        if (!double.TryParse(Console.ReadLine(), out double num2))
        {
            Console.WriteLine("Invalid number.");
            return;
        }

        double result;

        switch (op)
        {
            case '+':
                result = num1 + num2;
                break;
            case '-':
                result = num1 - num2;
                break;
            case '*':
                result = num1 * num2;
                break;
            case '/':
                if (num2 == 0)
                {
                    Console.WriteLine("Error: Division by zero.");
                    return;
                }
                result = num1 / num2;
                break;
            default:
                Console.WriteLine("Invalid operator.");
                return;
        }

        Console.WriteLine($"Result: {result}");
    }
}
