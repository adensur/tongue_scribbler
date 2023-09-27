//
//  StrokesLoad.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import Foundation

enum StrokePathComponent {
    case move(to: CGPoint)
    case addQuadCurve(to: CGPoint, control: CGPoint)
    case addCurve(to: CGPoint, control1: CGPoint, control2: CGPoint)
    case addLine(to: CGPoint)
    case closeSubpath
    case Arc(radiusX: Double, radiusY: Double, rotation: Double, largeArc: Bool, sweep: Bool, to: CGPoint)
}

struct StrokeData: Identifiable {
    var id: Int
    var outline: [StrokePathComponent]
    var medians: [CGPoint]
}

struct TCharacter {
    let character: String
    let strokes: [StrokeData]
    let strokeMap: [Int]
}

struct CharacterData: Decodable {
    var character: String
    var strokes: [String]
    var medians: [[[Double]]]
    var width: Double?
    var height: Double?
    var xOffset: Double?
    var yOffset: Double?
    var strokeMap: [Int]?
}

fileprivate func parseSVGPath(_ path: String, remapPoint: (CGPoint) -> CGPoint, radiusScale: Double) -> [StrokePathComponent] {
    let commands = path.split(separator: " ")
    var index = 0
    var result: [StrokePathComponent] = []
    
    while index < commands.count {
        let command = commands[index]
        switch command {
        case "M":
            let x = CGFloat(Double(commands[index + 1])!)
            let y = CGFloat(Double(commands[index + 2])!)
            let point = remapPoint(CGPoint(x: x, y: y))
            result.append(.move(to: point))
            index += 3
        case "Q":
            let x1 = CGFloat(Double(commands[index + 1])!)
            let y1 = CGFloat(Double(commands[index + 2])!)
            let x2 = CGFloat(Double(commands[index + 3])!)
            let y2 = CGFloat(Double(commands[index + 4])!)
            result.append(.addQuadCurve(to: remapPoint(CGPoint(x: x2, y: y2)),
                                        control: remapPoint(CGPoint(x: x1, y: y1))))
            index += 5
        case "L":
            let x = CGFloat(Double(commands[index + 1])!)
            let y = CGFloat(Double(commands[index + 2])!)
            result.append(.addLine(to: remapPoint(CGPoint(x: x, y: y))))
            index += 3
        case "Z":
            result.append(.closeSubpath)
            index += 1
        case "A":
            let rx = Double(commands[index + 1])!
            let ry = Double(commands[index + 2])!
            let rotation = Double(commands[index + 3])!
            let largeArc = Int(commands[index + 4])! > 0
            let sweep = Int(commands[index + 5])! > 0
            let x = CGFloat(Double(commands[index + 6])!)
            let y = CGFloat(Double(commands[index + 7])!)
            index += 8
            let to = remapPoint(CGPoint(x: x, y: y))
            if rx != ry {
                fatalError("Unequal radii for svg Arc not supported.")
            }
            result.append(.Arc(radiusX: rx * radiusScale, radiusY: rx * radiusScale, rotation: rotation, largeArc: largeArc, sweep: sweep, to: to))
        case "C":
            let x1 = CGFloat(Double(commands[index + 1])!)
            let y1 = CGFloat(Double(commands[index + 2])!)
            let x2 = CGFloat(Double(commands[index + 3])!)
            let y2 = CGFloat(Double(commands[index + 4])!)
            let x3 = CGFloat(Double(commands[index + 5])!)
            let y3 = CGFloat(Double(commands[index + 6])!)
            result.append(.addCurve(to: remapPoint(CGPoint(x: x3, y: y3)),
                                    control1: remapPoint(CGPoint(x: x1, y: y1)),
                                    control2: remapPoint(CGPoint(x: x2, y: y2))))
            index += 7
        default:
            print("Index: ", index, "command: ", command)
            print("Unexpected command: ", command)
            fatalError("Unexpected command!")
        }
    }
    
    return result
}

fileprivate func parseMedians(_ medians: [[Double]], remapPoint: (CGPoint) -> CGPoint) -> [CGPoint] {
    var result: [CGPoint] = []
    for pair in medians {
        guard pair.count == 2 else {
            fatalError("Corrupted data: parseMedians")
        }
        let point = CGPoint(x: pair[0], y: pair[1])
        result.append(remapPoint(point))
    }
    
    return result
}

fileprivate func parseData(_ data: CharacterData, character: String, chiHack: Bool) -> TCharacter? {
    if data.medians.count != data.strokes.count {
        return nil
    }
    var strokes: [StrokeData] = []
    for idx in 0..<data.medians.count {
        let remapPoint: (CGPoint) -> CGPoint
        if chiHack {
            remapPoint = {point in
                return CGPoint(
                    x: (point.x + (data.xOffset ?? 0.0)) / 1024.0,
                    y: (900 - point.y - (data.yOffset ?? 0.0)) / 1024.0
                )
            }
        } else {
            remapPoint = {point in
                return CGPoint(
                    x: (point.x + (data.xOffset ?? 0.0)) / (data.width ?? 1024.0),
                    y: (point.y + (data.yOffset ?? 0.0)) / (data.height ?? 1024.0)
                )
            }
        }
        let outline = parseSVGPath(data.strokes[idx], remapPoint: remapPoint, radiusScale: 1 / (data.width ?? 1024.0))
        strokes.append(StrokeData(id: idx, outline: outline, medians: parseMedians(data.medians[idx], remapPoint: remapPoint)))
    }
    let strokeMap = data.strokeMap ?? Array(0..<data.medians.count)
    if strokeMap.count != strokes.count {
        fatalError("Stroke map count != stroke count")
    }
    return TCharacter(character: character, strokes: strokes, strokeMap: strokeMap)
}

class CharacterHolder {
    var data: [String: TCharacter]
    
    init(data: [String : TCharacter]) {
        self.data = data
    }
    
    static func load(source: String) -> CharacterHolder {
        var res: [String: TCharacter] = [:]
        let url = if source == "chi" {
            Bundle.main.url(forResource: "chi", withExtension: "txt")!
        } else {
            Bundle.main.url(forResource: "hi", withExtension: "json")!
        }
        let chiHack = source == "chi" ? true : false
        
        let data = try! String(contentsOf: url)
        for line in data.split(separator: "\n") {
            let decoder = JSONDecoder()
            let characterData = try! decoder.decode(CharacterData.self, from: Data(line.utf8))
            res[characterData.character] = parseData(characterData, character: characterData.character, chiHack: chiHack)!
        }
        return CharacterHolder(data: res)
    }
    
    static func loadAll() -> CharacterHolder {
        var result = CharacterHolder(data: [:])
        for source in ["chi", "hi"] {
            let holder = Self.load(source: source)
            result.data.merge(holder.data) {key1, key2 in
                return key1
            }
        }
        return result
    }
}


let characterHolder = CharacterHolder.loadAll()
