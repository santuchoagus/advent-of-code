package main

import (
	"os"
	"regexp"
	"strconv"
)

type Pair struct {
	X, Y int
}

type Instruction int8

const (
	IsPair Instruction = iota
	IsDo
	IsDont
)

type PairOrInst struct {
	Instruction
	pair Pair
}

func parser_partone() (ret []Pair) {
	b, _ := os.ReadFile("input.txt")
	str := string(b)
	re, _ := regexp.Compile(`mul\((\d{1,3}),(\d{1,3})\)`)
	matches := re.FindAllStringSubmatch(str,-1)

	for _, match := range matches {
		x, _ := strconv.Atoi(match[1])
		y, _ := strconv.Atoi(match[2])
		ret = append(ret, Pair{x,y})
	}
	return
}

func parser_parttwo() (ret []PairOrInst) {
	b, _ := os.ReadFile("input.txt")
	str := string(b)
	re, _ := regexp.Compile(`do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)`)
	matches := re.FindAllStringSubmatch(str,-1)

	for _, match := range matches {
		pairOrInst := PairOrInst{}
		instruction := match[0]

		if instruction == `don't()` {
			pairOrInst.Instruction = IsDont
		} else if instruction == `do()` {
			pairOrInst.Instruction = IsDo
		} else {
			pairOrInst.Instruction = IsPair
			x, _ := strconv.Atoi(match[1])
			y, _ := strconv.Atoi(match[2])
			pairOrInst.pair = Pair{x,y}
		}
		ret = append(ret, pairOrInst)
	}
	return
}
