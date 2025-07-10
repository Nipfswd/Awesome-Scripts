import java.util.Scanner;

public class HelloAge {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("What is your name? ");
        String name = scanner.nextLine();

        System.out.print("How old are you? ");
        if (!scanner.hasNextInt()) {
            System.out.println("Please enter a valid number.");
            scanner.close();
            return;
        }
        int age = scanner.nextInt();

        if (age < 0) {
            System.out.println("Age cannot be negative.");
        } else {
            int futureAge = age + 10;
            System.out.println("Hello, " + name + "! In 10 years, you will be " + futureAge + " years old.");
        }

        scanner.close();
    }
}
