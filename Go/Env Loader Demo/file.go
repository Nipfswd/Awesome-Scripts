// Environment loader demo with fallback
package main

import (
	"fmt"
	"os"
)

// GetEnv returns the value of an environment variable,
// or a fallback if it isn't set.
func GetEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func main() {
    // Example variables
    port := GetEnv("APP_PORT", "8080")
    env := GetEnv("APP_ENV", "development")
    debug := GetEnv("DEBUG_MODE", "false")

    fmt.Println("App Port:", port)
    fmt.Println("App Env:", env)
    fmt.Println("Debug Mode:", debug)
}