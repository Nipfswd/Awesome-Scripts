package main

import (
	"flag"
	"fmt"
)

func main() {
	// Define flags
	name := flag.String("name", "world", "name to greet")
	verbose := flag.Bool("verbose", false, "enable verbose output")
	count := flag.Int("count", 1, "number of times to print the message")

	// Parse flags
	flag.Parse()

	// Optional -- remaining args after flags
	args := flag.Args()

	// Use flags
	for i := 0; i < *count; i++ {
		if *verbose {
			fmt.Printf("Gettings %s (iteration %d)\n", *name, i+1)
		} else {
			fmt.Printf("Hello, %s!\n", *name)
		}
	}

	// Show leftover args if any
	if len(args) > 0 {
		fmt.Println("Extra args:", args)
	}
}