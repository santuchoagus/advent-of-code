package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type update []int

type rule struct {
	before, after int
}

func parser() (rules []rule, updates []update) {
	readFile, err := os.Open("input.txt")

	if err != nil {
		fmt.Println(err)
	}
	fileScanner := bufio.NewScanner(readFile)

	fileScanner.Split(bufio.ScanLines)

	isRule := true

	for fileScanner.Scan() {
		text := fileScanner.Text()

		// Change to reading updates instead of rules
		if len(text) == 0 {
			isRule = false
			continue
		}

		if isRule {
			spl := strings.Split(text, "|")
			before, err1 := strconv.Atoi(spl[0])
			after, err2 := strconv.Atoi(spl[1])

			if err1 != nil || err2 != nil {
				log.Fatal("Error converting rule to integer:", err)
			}

			rules = append(rules, rule{before: before, after: after})

		} else { // This part process the updates
			spl := strings.Split(text, ",")
			update := make([]int, 0)

			for _, valueStr := range spl {
				valueInt, err := strconv.Atoi(valueStr)

				if err != nil {
					log.Fatal("Error converting string update to int:", err)
				}

				update = append(update, valueInt)
			}
			updates = append(updates, update)
		}
	}

	readFile.Close()
	return
}
