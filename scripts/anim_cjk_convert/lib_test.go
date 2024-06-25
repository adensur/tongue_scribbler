package main

import (
	"fmt"
	"testing"
)

func testExample(t *testing.T, str string, expected [][]float64) {
	actual := parseMedians(str)
	fmt.Printf("Actual: %v\n", actual)
	if len(expected) != len(actual) {
		t.Fatalf("Expected %d elements, got %d", len(expected), len(actual))
	}
	for idx := range expected {
		if len(expected[idx]) != len(actual[idx]) {
			t.Fatalf("Expected %d elements, got %d for index %d", len(expected[idx]), len(actual[idx]), idx)
		}
		for j := range expected[idx] {
			if expected[idx][j] != actual[idx][j] {
				t.Fatalf("Expected %f, got %f", expected[idx], actual[idx])
			}
		}
	}
}

func TestNumericParse(t *testing.T) {
	{
		str := "M 415,96 460,146 175,259"
		expected := [][]float64{
			{415, 96},
			{460, 146},
			{175, 259},
		}
		testExample(t, str, expected)
	}

	{
		str := "M415,96 460,146 175,259"
		expected := [][]float64{
			{415, 96},
			{460, 146},
			{175, 259},
		}
		testExample(t, str, expected)
	}

	{
		str := "M328 336L537 414L627 488"
		expected := [][]float64{
			{328, 336},
			{537, 414},
			{627, 488},
		}
		testExample(t, str, expected)
	}
}
