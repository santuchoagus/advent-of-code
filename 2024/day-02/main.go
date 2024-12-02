package main

import (
	"fmt"
	"log"
	"math"
	"os"
)

type Level struct {
	tuple []int
}

func (level Level) isSafe(tolerance int) bool {
	return bifurcate(level.tuple, tolerance, 1) || bifurcate(level.tuple, tolerance, -1)
}

func bifurcate(levelseq []int, tolerance int, dir int) bool {
	seq := make([]int, len(levelseq))
	copy(seq, levelseq)
	// If there
	if len(seq) <= 1 { return true }

	for i := 0 ; i < len(seq)-1; i++ {
		grad := seq[i+1] - seq[i]
		if dir * grad > 0 && math.Abs(float64(grad)) <= 3 {
			continue
		}
		// Only recurse if you have tolerance left
		if tolerance == 0 {return false }

		var branch1 []int
		var branch2 []int

		if i != 0 {
			// If it's not the first element, gets the previous one too
			branch1 = append([]int{seq[i-1]}, seq[i+1:]...)
		} else {
			branch1 = seq[i+1:]
		}
		branch2 = append([]int{seq[i]}, seq[i+2:]...)
		return bifurcate(branch1,tolerance-1,dir) || bifurcate(branch2,tolerance-1,dir)
	}
	return true
}

func main() {
	file, err := os.Open("input.txt")
	defer file.Close()

	if err != nil {
		log.Fatal("Failed to read input for some weird reason")
	}

	levels := readLevels(file)

	// Part one
	var safeLevelCount int = 0
	for _, lvl := range levels {
		if lvl.isSafe(0) {
			safeLevelCount++
		}
	}
	fmt.Printf("(part one) %d reports are safe.\n", safeLevelCount)

	// Part two
	safeLevelCount = 0
	for _, lvl := range levels {
		if lvl.isSafe(1) {
			safeLevelCount++
		}
	}
	fmt.Printf("(part two) %d reports are safe.\n", safeLevelCount)
	return
}
