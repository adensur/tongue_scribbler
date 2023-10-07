package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type Point struct {
	x float64
	y float64
}

func parseNumSequence(str string) []float64 {
	fmt.Printf("parse num sequence: %s\n", str)
	// Parse a string like that:
	// -1.4-.8-2.4,1.1
	// spaces are equal to commas and are used as separators
	// . (dot) can be used as a separator if it is not ambiguous
	idx := 0
	nums := []float64{}
	buf := strings.Builder{}
	metDot := false
	metMinus := false
	for idx < len(str) {
		ch := str[idx]
		if ch == ' ' || ch == ',' || (ch == '.' && metDot) || (ch == '-' && (metMinus || metDot)) {
			// flush current buf if it is not empty
			if buf.Len() > 0 {
				numStr := buf.String()
				num, err := strconv.ParseFloat(numStr, 64)
				if err != nil {
					panic(err)
				}
				nums = append(nums, num)
			}
			buf.Reset()
			// we still need the dot to parse next number
			if !(ch == '.' || ch == '-') {
				idx++
			}
			metDot = false
			metMinus = false
			continue
		}
		if ch == '.' {
			metDot = true
			buf.WriteByte(ch)
			idx += 1
			continue
		}
		if ch == '-' {
			metMinus = true
			buf.WriteByte(ch)
			idx += 1
			continue
		}
		if ch >= '0' && ch <= '9' || ch == '.' {
			metMinus = true
		}
		if ch == '+' || (ch >= '0' && ch <= '9') {
			buf.WriteByte(ch)
			idx++
			continue
		}
		panic(fmt.Errorf("Unexpected character: %c while parsing command %s", ch, str))
	}
	if buf.Len() > 0 {
		numStr := buf.String()
		num, err := strconv.ParseFloat(numStr, 64)
		if err != nil {
			panic(err)
		}
		nums = append(nums, num)
	}
	return nums
}

func convertPath(path string) (string, []Point, error) {
	curX := 0.0
	curY := 0.0
	var sb strings.Builder
	var err error

	re := regexp.MustCompile(`([MmlLhHvVcCzZqQaAs])([^MmlLhHvVcCzZqQaAs]*)`)
	commands := re.FindAllString(path, -1)

	medians := []Point{}

	var prevControl *Point = nil

	for _, commandStr := range commands {
		fmt.Printf("Command: %s\n", commandStr)
		command := string(commandStr[0])
		fmt.Printf("Command: %s\n", command)
		if command == "z" {
			sb.WriteString("Z ")
			continue
		} else if command == "Z" {
			sb.WriteString("Z ")
			continue
		} else if command == "m" {
			sb.WriteString("M ")
		} else if command == "M" {
			sb.WriteString("M ")
		} else if command == "l" {
			sb.WriteString("L ")
		} else if command == "L" {
			sb.WriteString("L ")
		} else if command == "h" {
			sb.WriteString("L ")
		} else if command == "H" {
			sb.WriteString("L ")
		} else if command == "v" {
			sb.WriteString("L ")
		} else if command == "V" {
			sb.WriteString("L ")
		} else if command == "q" {
			sb.WriteString("Q ")
		} else if command == "Q" {
			sb.WriteString("Q ")
		} else if command == "c" {
			sb.WriteString("C ")
		} else if command == "C" {
			sb.WriteString("C ")
		} else if command == "a" {
			sb.WriteString("A ")
		} else if command == "A" {
			sb.WriteString("A ")
		} else if command == "s" {
			sb.WriteString("C ")
		}
		idx := 0
		coords := parseNumSequence(commandStr[1:])
		succ := false
		for idx < len(coords) {
			if command == "m" {
				// need to read at least 2 coords
				if idx+1 >= len(coords) {
					panic("Expected at least 2 coords")
				}
				if idx > 0 {
					sb.WriteString("M ")
				}
				coord1 := coords[idx]
				coord2 := coords[idx+1]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 2
			} else if command == "M" {
				// need to read at least 2 coords
				if idx+1 >= len(coords) {
					panic("Expected at least 2 coords")
				}
				if idx > 0 {
					sb.WriteString("M ")
				}
				coord1 := coords[idx]
				coord2 := coords[idx+1]
				succ = true
				curX = coord1
				curY = coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 2
			} else if command == "l" {
				// need to read at least 2 coords
				if idx+1 >= len(coords) {
					panic("Expected at least 2 coords")
				}
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				coord2 := coords[idx+1]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 2
			} else if command == "L" {
				// need to read at least 2 coords
				if idx+1 >= len(coords) {
					panic("Expected at least 2 coords")
				}
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				coord2 := coords[idx+1]
				succ = true
				curX = coord1
				curY = coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 2
			} else if command == "h" {
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				succ = true
				curX += coord1
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 1
			} else if command == "H" {
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				succ = true
				curX = coord1
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 1
			} else if command == "v" {
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				succ = true
				curY += coord1
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 1
			} else if command == "V" {
				if idx > 0 {
					sb.WriteString("L ")
				}
				coord1 := coords[idx]
				succ = true
				curY = coord1
				sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 1
			} else if command == "q" {
				// need to read at least 4 coords
				if idx+3 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("Q ")
				}
				controlX := curX + coords[idx]
				controlY := curY + coords[idx+1]
				coord1 := coords[idx+2]
				coord2 := coords[idx+3]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %.2f", controlX, controlY, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 4
			} else if command == "Q" {
				// need to read at least 4 coords
				if idx+3 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("Q ")
				}
				controlX := coords[idx]
				controlY := coords[idx+1]
				coord1 := coords[idx+2]
				coord2 := coords[idx+3]
				succ = true
				curX = coord1
				curY = coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %.2f", controlX, controlY, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 4
			} else if command == "c" {
				// need to read at least 6 coords
				if idx+5 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("C ")
				}
				control1X := curX + coords[idx]
				control1Y := curY + coords[idx+1]
				control2X := curX + coords[idx+2]
				control2Y := curY + coords[idx+3]
				coord1 := coords[idx+4]
				coord2 := coords[idx+5]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %.2f %.2f %.2f", control1X, control1Y, control2X, control2Y, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 6
				prevControl = &Point{control2X, control2Y}
			} else if command == "C" {
				// need to read at least 6 coords
				if idx+5 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("C ")
				}
				control1X := coords[idx]
				control1Y := coords[idx+1]
				control2X := coords[idx+2]
				control2Y := coords[idx+3]
				coord1 := coords[idx+4]
				coord2 := coords[idx+5]
				succ = true
				curX = coord1
				curY = coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %.2f %.2f %.2f", control1X, control1Y, control2X, control2Y, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 6
				prevControl = &Point{control2X, control2Y}
			} else if command == "a" {
				// need to read at least 7 coords
				if idx+6 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("A ")
				}
				radiusX := coords[idx]
				radiusY := coords[idx+1]
				rotation := coords[idx+2]
				largeArcFlag := int(coords[idx+3])
				sweepFlag := int(coords[idx+4])
				coord1 := coords[idx+5]
				coord2 := coords[idx+6]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %d %d %.2f %.2f", radiusX, radiusY, rotation, largeArcFlag, sweepFlag, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 7
			} else if command == "A" {
				// need to read at least 7 coords
				if idx+6 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("A ")
				}
				radiusX := coords[idx]
				radiusY := coords[idx+1]
				rotation := coords[idx+2]
				largeArcFlag := int(coords[idx+3])
				sweepFlag := int(coords[idx+4])
				coord1 := coords[idx+5]
				coord2 := coords[idx+6]
				succ = true
				curX = coord1
				curY = coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %d %d %.2f %.2f", radiusX, radiusY, rotation, largeArcFlag, sweepFlag, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 7
			} else if command == "s" {
				// need to read at least 4 coords
				if idx+3 >= len(coords) {
					panic("Expected at least 4 coords")
				}
				if idx > 0 {
					sb.WriteString("C ")
				}
				if prevControl == nil {
					prevControl = &Point{curX, curY}
				}
				// calculate control1 as reflection of prev control
				control1X := curX + (curX - prevControl.x)
				control1Y := curY + (curY - prevControl.y)
				control2X := curX + coords[idx]
				control2Y := curY + coords[idx+1]
				prevControl = &Point{control2X, control2Y}
				coord1 := coords[idx+2]
				coord2 := coords[idx+3]
				succ = true
				curX += coord1
				curY += coord2
				sb.WriteString(fmt.Sprintf("%.2f %.2f %.2f %.2f %.2f %.2f", control1X, control1Y, control2X, control2Y, curX, curY))
				medians = append(medians, Point{curX, curY})
				idx += 4
			} else {
				panic("Unknown command: " + command)
			}
			if !succ {
				panic(fmt.Errorf("Malformed command: %s\n", commandStr))
			}
		}
	}
	return sb.String(), medians, err
}
