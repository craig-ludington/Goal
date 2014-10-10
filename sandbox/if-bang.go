package main

import (
	"fmt"
)

func f() (int, error) {
	return 1, nil
}

func g(x,y,z int) (int, error) {
	return 1, nil
}

func main() {
	if x, err := f(); err != nil {
		Printf("Lose: %v\n", err)
	} else {
		Printf("Win: %d\n", x)
	}


	if y, err := g(1, 2, 3); err != nil {
		Printf("Fail")
	} else {
		Printf("Success")
	}


}
