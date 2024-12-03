package main

import "fmt"

func main() {
	pairs := parser_partone()
	acum := 0
	for _, pair := range pairs {
		acum += pair.X * pair.Y
	}
	fmt.Println(acum)

	// Part two
	instPairs := parser_parttwo()
	multiplier := 1 // flag to ignore next inst
	acum = 0
	for _, inst := range instPairs {
		if inst.Instruction == IsDo {
			multiplier = 1
		} else if inst.Instruction == IsDont {
			multiplier = 0
		}
		acum += multiplier * inst.pair.X * inst.pair.Y
	}
	fmt.Printf("%d", acum)
	return
}
