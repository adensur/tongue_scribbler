package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	// read original path from stdin
	reader := bufio.NewReader(os.Stdin)
	originalPath, _ := reader.ReadString('\n')
	fmt.Printf("Original path: %s\n", originalPath)
	path, err := convertPath(originalPath)
	if err != nil {
		fmt.Println("Error converting path:", err)
		return
	}
	fmt.Println(path)
}

func convertPath(path string) (string, error) {
	curX := 0.0
	curY := 0.0
	var sb strings.Builder
	var err error

	re := regexp.MustCompile(`([MmlLhHvVcCzZqQaA])([^MmlLhHvVcCzZqQaA]*)`)
	commands := re.FindAllString(path, -1)

	for _, command := range commands {
		components := strings.Split(command, " ")
		command = components[0]
		fmt.Printf("Command: %s\n", command)
		if command == "z" {
			sb.WriteString("Z ")
			continue
		} else if command == "Z" {
			sb.WriteString("Z ")
			continue
		}
		for idx := range components {
			if idx == 0 || components[idx] == "" {
				continue
			}

			coordsStr := strings.Split(components[idx], ",")
			var coords []float64
			for _, coordStr := range coordsStr {
				coord, err := strconv.ParseFloat(coordStr, 64)
				if err != nil {
					return "", err
				}
				coords = append(coords, coord)
			}
			if command == "m" {
				if idx == 1 {
					curX += coords[0]
					curY += coords[1]
					sb.WriteString(fmt.Sprintf("M %.2f %.2f ", curX, curY))
				} else {
					curX += coords[0]
					curY += coords[1]
					// subsequent commands draw a line
					sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
				}
			} else if command == "M" {
				if idx == 1 {
					curX = coords[0]
					curY = coords[1]
					sb.WriteString(fmt.Sprintf("M %.2f %.2f ", curX, curY))
				} else {
					curX = coords[0]
					curY = coords[1]
					// subsequent commands draw a line
					sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
				}
			} else if command == "l" {
				curX += coords[0]
				curY += coords[1]
				sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
			} else if command == "h" {
				curX += coords[0]
				sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
			} else if command == "H" {
				curX = coords[0]
				sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
			} else if command == "v" {
				curY += coords[0]
				sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
			} else if command == "V" {
				curY = coords[0]
				sb.WriteString(fmt.Sprintf("L %.2f %.2f ", curX, curY))
			} else if command == "q" {
				if idx == 0 {
					continue
				}
				if (idx-1)%2 == 0 {
					// control point goes first. No need to increment curX/curY
					sb.WriteString(fmt.Sprintf("Q %.2f %.2f ", curX+coords[0], curY+coords[1]))
				} else {
					curX += coords[0]
					curY += coords[1]
					sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				}
			} else if command == "Q" {
				if (idx-1)%2 == 0 {
					// control point goes first. No need to increment curX/curY
					sb.WriteString(fmt.Sprintf("Q %.2f %.2f ", coords[0], coords[1]))
				} else {
					curX = coords[0]
					curY = coords[1]
					sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				}
			} else if command == "a" {
				if idx == 0 {
					continue
				}
				if (idx-1)%5 == 0 {
					// radius part, write as is
					sb.WriteString(fmt.Sprintf("A %.2f %.2f ", coords[0], coords[1]))
				} else if (idx-1)%5 == 1 {
					// rotation part, write as is
					sb.WriteString(fmt.Sprintf("%.2f ", coords[0]))
				} else if (idx-1)%5 == 2 {
					// large arc flag, write as is
					sb.WriteString(fmt.Sprintf("%d ", int(coords[0])))
				} else if (idx-1)%5 == 3 {
					// sweep flag, write as is
					sb.WriteString(fmt.Sprintf("%d ", int(coords[0])))
				} else if (idx-1)%5 == 4 {
					// coordinates
					curX += coords[0]
					curY += coords[1]
					sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				}
			} else if command == "A" {
				if idx == 0 {
					continue
				}
				if (idx-1)%5 == 0 {
					// radius part, write as is
					sb.WriteString(fmt.Sprintf("A %.2f %.2f ", coords[0], coords[1]))
				} else if (idx-1)%5 == 1 {
					// rotation part, write as is
					sb.WriteString(fmt.Sprintf("%.2f ", coords[0]))
				} else if (idx-1)%5 == 2 {
					// large arc flag, write as is
					sb.WriteString(fmt.Sprintf("%d ", int(coords[0])))
				} else if (idx-1)%5 == 3 {
					// sweep flag, write as is
					sb.WriteString(fmt.Sprintf("%d ", int(coords[0])))
				} else if (idx-1)%5 == 4 {
					// coordinates
					curX = coords[0]
					curY = coords[1]
					sb.WriteString(fmt.Sprintf("%.2f %.2f ", curX, curY))
				}
			} else {
				panic("Unknown command: " + command)
			}
		}
	}

	return sb.String(), err
}
