package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"golang.org/x/net/html"
)

var (
	input = flag.String("input", "", "Input file")
)

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
