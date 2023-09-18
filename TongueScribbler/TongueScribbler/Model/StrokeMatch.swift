//
//  StrokeMatch.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 18/09/2023.
//

import Foundation



func dedup(_ stroke: [CGPoint]) -> [CGPoint] {
    if stroke.count <= 1 {
        return stroke
    }
    var res = Array<CGPoint>()
    for idx in 1..<stroke.count {
        if stroke[idx] != stroke[idx - 1] {
            res.append(stroke[idx])
        }
    }
    return res
}

func distance(_ point1: CGPoint, _ point2: CGPoint) -> Double {
    let xDist = point2.x - point1.x
    let yDist = point2.y - point1.y
    return sqrt((xDist * xDist) + (yDist * yDist))
}

func averageDistance(from: [CGPoint], to: [CGPoint]) -> Double {
    return to.reduce(0.0) {total, point in
        let distances = from.map { distance($0, point)}
        let newDistance = distances.min()!
        print("newDistance: ", newDistance)
        return total + newDistance
    } / Double(to.count)
}

func strokesMatch(userStroke: [CGPoint], characterStroke: [CGPoint]) -> Bool {
    print("Trying to match strokes. User stroke: \(userStroke), character stroke: \(characterStroke)")
    if userStroke.count <= 1 {
        return false
    }
    let userStroke = dedup(userStroke)
    let avgDistance = averageDistance(from: userStroke, to: characterStroke)
    print("Avg distance: \(avgDistance)")
    if avgDistance < 0.1 {
        return true
    }
    return false
}
