package main

import (
	"os"
)

func getCandidatesOf(candidate rune) (ret [][]byte, possible_pos [][]int) {
	b, _ := os.ReadFile("input.txt")
	str := string(b)

	rowLength := 0
	for i, chr := range str {
		if chr == '\n' {
			rowLength = i + 1
			break
		}
	}

	row := []byte{}
	for n, chr := range str {
		if chr == candidate {
			x := n % rowLength
			y := n / rowLength
			possible_pos = append(possible_pos, []int{x,y})
		}

		if chr == '\n' {
			ret = append(ret, row)
			row = []byte{}
			continue
		}

		row = append(row, byte(chr))
	}
	return
}
