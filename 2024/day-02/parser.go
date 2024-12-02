package main

import (
	"io"
	"strconv"
	"os"
)
// Parses text as Level struct and returns an slice of levels
func readLevels(r *os.File) (levels []Level) {
	var b []byte = make([]byte, 1)
	var levelBuf *Level = new(Level)
	var numberBuf string = ""

	for {
		_, err := r.Read(b)
		var char byte = b[0]
		if err == io.EOF {
			if numberBuf != "" {
				number, _ := strconv.Atoi(numberBuf)
				levelBuf.tuple = append(levelBuf.tuple, number)
				levels = append(levels, *levelBuf)
			}
			return
		}

		if char == ' ' {
			number, _ := strconv.Atoi(numberBuf)
			levelBuf.tuple = append(levelBuf.tuple, number)
			numberBuf = ""
			continue
		}
		// Assuming there is no newline without a number behind it.
		if char == '\n' {
			number, _ := strconv.Atoi(numberBuf)
			levelBuf.tuple = append(levelBuf.tuple, number)
			numberBuf = ""

			levels = append(levels, *levelBuf)
			levelBuf = new(Level)
			continue
		}
		// If flow reach this point the char is assummed to be a number
		numberBuf += string(char)
	}
}
