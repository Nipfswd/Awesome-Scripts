int RollDice(int sides)
{
    // Simple random number generator between 1 and sides
    return 1 + int(rnd() * sides);
}

void main()
{
    int sides = 6;  // Number of sides on the dice
    int roll = RollDice(sides);
    print("You rolled a " + roll + " on a " + sides + "-sided dice.\n");
}
