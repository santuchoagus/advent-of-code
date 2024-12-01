package main

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

type trimReader struct { io.Reader }

func (tr trimReader) Read(bs []byte) (int, error) {
	n, err := tr.Reader.Read(bs)

	if err != nil {
		return n, err
	}

	lines := string(bs[:n])

	re := regexp.MustCompile(` +`)

	trimmed := []byte(re.ReplaceAllString(lines, ","))
	copy(bs, trimmed)
	return len(trimmed), nil
}

func main() {
	file, err := os.Open("input.csv")
	defer file.Close()

	if err != nil {
		log.Fatal("Error opening file")
	}

	var r *strings.Reader

	if b, err := io.ReadAll(file); err == nil {
		content := string(b)
		re := regexp.MustCompile(` +`)
		trimmed := re.ReplaceAllString(content, ",")
		r = strings.NewReader(trimmed)
	}

	csvReader := csv.NewReader(r)
	data, err := csvReader.ReadAll()
	_ = data

	transposed := make([][]int, 2)
	for i := range transposed {
		transposed[i] = make([]int, len(data))
	}

	for i, row := range data {
		transposed[0][i], err1 = strconv.Atoi(row[0])
		transposed[1][i], err2 = strconv.Atoi(row[1])

		if err1 != nil || err2 != nil {
			log.Fatal("Error converting row to int")
		}
	}

	slices.Sort(transposed[0])
	slices.Sort(transposed[1])

	for i := range transposed[0] {
		result1 += int(math.Abs(float64(transposed[0][i] - transposed[1][i])))
	}

	// Part 2
	for _, n := range transposed[0] {
		result2 += n * CountAppearances(n, transposed[1])
	}



	fmt.Println("Result part one:", result1)
	fmt.Println("Result part two:", result2)
	return
}

func CountAppearances[C comparable](c C, slice []C) (count int) {
	for _, elem := range slice {
		if c == elem {
			count++
		}
	}
	return
}

var (
	result1 int = 0
	result2 int = 0
	err1 error
	err2 error
)
