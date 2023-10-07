package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"strings"
)

func main() {
	// read original path from stdin
	reader := bufio.NewReader(os.Stdin)
	originalPath, _ := reader.ReadString('\n')
	fmt.Printf("Original path: %s\n", originalPath)
	// strip \n at the end of originalPath
	originalPath = strings.TrimSuffix(originalPath, "\n")
	// originalPath := " 0,27.301 4.9,-1.7 "
	// seq := parseNumSequence(originalPath)
	// fmt.Printf("Parsed sequence: %v\n", seq)
	// return

	path, medians, err := convertPath(originalPath)
	if err != nil {
		fmt.Println("Error converting path:", err)
		return
	}
	fmt.Printf("Path: %s\n", path)
	// serialise medians in 2d json array like [[x1,y1],[x2,y2],...]
	arr := [][]float64{}
	for _, median := range medians {
		arr = append(arr, []float64{median.x, median.y})
	}
	js, err := json.Marshal(arr)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Medians: %v\n", string(js))
}
