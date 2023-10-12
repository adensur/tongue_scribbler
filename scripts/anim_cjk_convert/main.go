package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"

	"golang.org/x/net/html"
)

var (
	input = flag.String("input", "", "Input file")
)

type MyNode struct {
	Attrs map[string]string
}

func NewNode(n *html.Node) MyNode {
	m := MyNode{}
	m.Attrs = make(map[string]string)
	for _, attr := range n.Attr {
		m.Attrs[attr.Key] = attr.Val
	}
	return m
}

type Result struct {
	Character string        `json:"character"`
	Strokes   []string      `json:"strokes"`
	Medians   [][][]float64 `json:"medians"`
	StrokeMap []int32       `json:"strokeMap"`
}

func parseMedians(str string) [][]float64 {
	// M 240,394 302,434 453,432 659,380 -> [[240,394], [302,434], [453,432], [659,380]]
	values := strings.Split(str, " ")
	medians := [][]float64{}
	for _, value := range values {
		if value == "M" {
			continue
		}
		// 240,394 -> [240,394]
		xy := strings.Split(value, ",")
		x, err := strconv.ParseFloat(xy[0], 64)
		if err != nil {
			panic(err)
		}
		y, err := strconv.ParseFloat(xy[1], 64)
		if err != nil {
			panic(err)
		}
		medians = append(medians, []float64{x, y})
	}
	return medians
}

func Process(n *html.Node, prefix, codePointStr string, result *Result) {
	node := NewNode(n)
	if n.Data == "path" {
		id := node.Attrs["id"]
		style := node.Attrs["style"]
		if id != "" {
			result.Strokes = append(result.Strokes, node.Attrs["d"])
			// z12353d1 -> 1
			values := strings.Split(id, "d")
			strokeNumberStr := values[len(values)-1]
			// 1a -> 1
			strokeNumberStr = strings.TrimRight(strokeNumberStr, "abcdefghijklmnopqrstuvwxyz")
			strokeNumber, err := strconv.ParseInt(strokeNumberStr, 10, 32)
			if err != nil {
				panic(err)
			}
			result.StrokeMap = append(result.StrokeMap, int32(strokeNumber-1))
			// fmt.Printf("Found a path, id: %v, path: %v, stroke number: %v\n", id, node.Attrs["d"], strokeNumber)
		} else if style != "" {
			medians := parseMedians(node.Attrs["d"])
			result.Medians = append(result.Medians, medians)
			// fmt.Printf("Medians: %v\n", medians)
		}
	}
	idx := 0
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		Process(c, fmt.Sprintf("%s[%v]/%s", prefix, idx, n.Data), codePointStr, result)
		idx += 1
	}
}

func getCodePoint(input string) string {
	// ~/repos/animCJK/svgsKana/12353.svg -> 12353
	values := strings.Split(input, "/")
	filename := values[len(values)-1]
	values = strings.Split(filename, ".")
	codePointStr := values[0]
	return codePointStr
}

func getCharacter(codePointStr string) (string, error) {
	// 12353 -> ぁ
	codePoint, err := strconv.ParseInt(codePointStr, 10, 32)
	if err != nil {
		return "", fmt.Errorf("Error parsing code point:", err)
	}
	unicodeChar := string(rune(codePoint))
	return unicodeChar, nil
}

func main() {
	flag.Parse()
	if len(*input) == 0 {
		fmt.Printf("Expected input file!\n")
		panic("Expected input file!")
	}
	// getting character
	codePointStr := getCodePoint(*input)
	character, err := getCharacter(codePointStr)
	if err != nil {
		panic(err)
	}
	result := Result{}
	// fmt.Printf("Character: %v\n", character)
	result.Character = character
	r, err := os.Open(*input)
	if err != nil {
		panic(err)
	}
	defer r.Close()
	doc, err := html.Parse(r)
	if err != nil {
		panic(err)
	}
	Process(doc, "/", codePointStr, &result)
	js, err := json.Marshal(result)
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s\n", js)
}
