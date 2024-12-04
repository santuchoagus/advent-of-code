package main

import "fmt"

func main() {
	char_matrix ,possible_pos := getCandidatesOf('X')
	foundCount := 0

	for _, pos := range possible_pos {
		x, y := pos[0], pos[1]

		// Start the search in the 8 different directions
		// ? ? ?
		// ? X ?
		// ? ? ?

		for n := 0; n < 9; n++ {
				dx := (n % 3) - 1
				dy := (n / 3) - 1
				found := keepSearching("XMAS", char_matrix, []int{x,y}, []int{dx, dy})
				if found {
					foundCount++
				}
			}
	}
	fmt.Println("Part one count:",foundCount)

	// Part 2
	foundCount = 0
	// Idea
	// Find an A, make sure A is not at the border
	// p * p
	// * A *
	// p * p
	// Recurse from points "p" to the direction of "A" trying to find "MAS"
	// it's guaranteed that is a "X-mas" if it finds 2.
	char_matrix2, centerCandidates := getCandidatesOf('A')

	matrixMaxCol, matrixMaxRow := len(char_matrix2), len(char_matrix2[0])

	for _, candidate := range centerCandidates {
		x, y := candidate[0], candidate[1]
		// Remove "A's" that are at the border of the matrix
		if (x == 0 || y == 0 || x == matrixMaxRow - 1 || y == matrixMaxCol - 1 ) { continue }

		hitCount := 0
		if keepSearching("MAS", char_matrix2, []int{x-1,y-1}, []int{1,1}) { hitCount++ }
		if keepSearching("MAS", char_matrix2, []int{x+1,y-1},[]int{-1,1}) { hitCount++ }
		if keepSearching("MAS", char_matrix2, []int{x-1,y+1},[]int{1,-1}) { hitCount++ }
		if keepSearching("MAS", char_matrix2, []int{x+1,y+1},[]int{-1,-1}) { hitCount++ }

		// hit count of 2 means two cornes forms an "MAS" with the same center.
		if hitCount == 2 {
			foundCount++
		}
	}
	fmt.Println("Part two count:",foundCount)
	return
}

// Checks that the first letter of the word is at the position of curr_pos.
// if that happens, then it will call himself with the word removing it's first letter, and with
// the curr_pos being the curr_pos + direction, when there is no word to search returns true.
func keepSearching(word string, matrix [][]byte, curr_pos []int, direction []int) bool {
	// if there are any char to search next, the candidate is true.
	if len(word) == 0 { return true }

	shouldBe_char := word[0]
	nextWord := word[1:]

	matrixMax_X := len(matrix[0])
	matrixMax_Y := len(matrix)

	x, y := curr_pos[0], curr_pos[1]
	next_x := x + direction[0] // + dx
	next_y := y + direction[1] // + dy

	// if out of range return false
	if !(x >= 0 && y >= 0) { return false }
	if !(x < matrixMax_X && y < matrixMax_Y) { return false }

	actual_char := matrix[y][x]
	if shouldBe_char != actual_char { return false }

	return keepSearching(nextWord, matrix, []int{next_x, next_y}, direction)
}
