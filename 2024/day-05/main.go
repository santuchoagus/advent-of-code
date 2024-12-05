package main

import (
	"fmt"
	"log"
	"slices"
)

func ruleMap(rules []rule, updates []update) (ruleBeforeMap map[int]update) {
	ruleBeforeMap = make(map[int]update)

	for _, rule := range rules {
		// Afternum will be the map key, I'm going to map every number
		// before the "after" number.
		afternum := rule.after
		beforenum := rule.before

		if beforeMap, ok := ruleBeforeMap[afternum]; ok {
			// It doesn't matter if there are duplicate "before" numbers
			ruleBeforeMap[afternum] = append(beforeMap, beforenum)
		} else {
			// Creates a new slice of befores for this entry
			ruleBeforeMap[afternum] = []int{beforenum}
		}
	}
	return
}

func (update update) isValid(rules map[int]update) bool {
	// Checks if each number comes before the next number on the list,
	// which shouldn't be possible, returns false when that happens.
	for i := range update {
		afterNum := update[i]
		beforeNumSlice := rules[afterNum]

		for j := i + 1; i < len(update)-1; i++ {
			// This means that update[j] which is far ahead on the slice than afterNum
			// should be before afterNum on the list, therefore it's not valid.
			if slices.Contains(beforeNumSlice, update[j]) {
				return false
			}
		}
	}
	return true
}

func main() {
	rules, updates := parser()

	// ruleMap function returns a map where each key is an "after" number
	// (i.e. numbers that appear after "|") to a list of the numbers that come before it
	ruleBeforeMap := ruleMap(rules, updates)
	result := 0

	for _, update := range updates {
		// Skip invalid updates
		if !update.isValid(ruleBeforeMap) {
			continue
		}

		// Get the middle page number of the update for adding up the result.
		middlePageNumber := update[len(update)/2]
		result += middlePageNumber
	}
	fmt.Println("Part one result is:", result)

	// # # Part 2
	// # A.K.A. No me leí el Cormen todavía
	// #

	result = 0
	// Same for loop as above but just invert the guard clause to get the invalid ones.
	for _, upd := range updates {
		// Skip valid updates
		if upd.isValid(ruleBeforeMap) {
			continue
		}

		orderedUpd := orderUpdate(upd, ruleBeforeMap)

		// Get the middle page number of the update for adding up the result.
		middlePageNumber := orderedUpd[len(orderedUpd)/2]
		result += middlePageNumber
	}
	fmt.Println("Part two result is:", result)
	return
}

func orderUpdate(upd update, rules map[int]update) (orderedUpd update) {
	maxLoops := 100000000 // NASA APPROVED
	if len(upd) < 2 {
		return upd
	} // Assume it has atleast two values

	orderedUpd = upd
	// Cycle until it's completely ordered
	for !orderedUpd.isValid(rules) {
		maxLoops--
		if maxLoops <= 0 {
			log.Fatal("Loop was too long")
		}

		//[...beforeSlice...] + afterNum + [...remainderSlice...]
		beforeSlice, remainderSlice := make(update, 0), make(update, 0)
		// The role of this one is adding themselves at the back when they pass the check
		passedBefore := make(update, 0)
		var afterNum int // Will be assigned per loop
		//61,13,29

		for i := range orderedUpd {
			// This guard means the previous iteration reordered, so we should effect the changes
			if len(beforeSlice) > 0 {
				break
			} else if i != 0 {
				// Not the first iteration, append the previous iteration to the beginning of the slice
				passedBefore = append(passedBefore, afterNum)
			}
			remainderSlice = make(update, 0) // Clean the remainder to keep iterating.
			afterNum = orderedUpd[i]
			ruleBeforeSlice := rules[afterNum]

			for j := i + 1; j <= len(orderedUpd)-1; j++ {
				numberAhead := orderedUpd[j]
				if slices.Contains(ruleBeforeSlice, numberAhead) {
					beforeSlice = append(beforeSlice, numberAhead)
				} else {
					remainderSlice = append(remainderSlice, numberAhead)
				}
			}
		}

		//[...passedBefore + beforeSlice...] + afterNum + [...remainderSlice...]
		orderedUpd = slices.Concat(passedBefore, beforeSlice, update{afterNum}, remainderSlice)
	}
	return
}
