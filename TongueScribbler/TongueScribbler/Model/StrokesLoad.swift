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
}

struct CharacterData: Decodable {
    var character: String
    var strokes: [String]
    var medians: [[[Double]]]
    var width: Double?
    var height: Double?
}

fileprivate func remapPoint(_ point: CGPoint, chiHack: Bool, width: Double, height: Double) -> CGPoint {
    // https://github.com/skishore/makemeahanzi/tree/master#graphicstxt-keys
    if chiHack {
        return CGPoint(
            x: point.x / 1024,
            y: (900 - point.y) / 1024.0
        )
    } else {
        return CGPoint(
            x: point.x / width,
            y: point.y / height
        )
    }
        
}

fileprivate func parseSVGPath(_ path: String, chiHack: Bool, width: Double, height: Double) -> [StrokePathComponent] {
    let commands = path.split(separator: " ")
    var index = 0
    var result: [StrokePathComponent] = []
    
    while index < commands.count {
        let command = commands[index]
        switch command {
        case "M":
            let x = CGFloat(Double(commands[index + 1])!)
            let y = CGFloat(Double(commands[index + 2])!)
            let point = remapPoint(CGPoint(x: x, y: y), chiHack: chiHack, width: width, height: height)
            result.append(.move(to: point))
            index += 3
        case "Q":
            let x1 = CGFloat(Double(commands[index + 1])!)
            let y1 = CGFloat(Double(commands[index + 2])!)
            let x2 = CGFloat(Double(commands[index + 3])!)
            let y2 = CGFloat(Double(commands[index + 4])!)
            result.append(.addQuadCurve(to: remapPoint(CGPoint(x: x2, y: y2), chiHack: chiHack, width: width, height: height),
                                        control: remapPoint(CGPoint(x: x1, y: y1), chiHack: chiHack, width: width, height: height)))
            index += 5
        case "L":
            let x = CGFloat(Double(commands[index + 1])!)
            let y = CGFloat(Double(commands[index + 2])!)
            result.append(.addLine(to: remapPoint(CGPoint(x: x, y: y), chiHack: chiHack, width: width, height: height)))
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
            let to = remapPoint(CGPoint(x: x, y: y), chiHack: chiHack, width: width, height: height)
            result.append(.Arc(radiusX: rx / width, radiusY: ry / height, rotation: rotation, largeArc: largeArc, sweep: sweep, to: to))
        case "C":
            let x1 = CGFloat(Double(commands[index + 1])!)
            let y1 = CGFloat(Double(commands[index + 2])!)
            let x2 = CGFloat(Double(commands[index + 3])!)
            let y2 = CGFloat(Double(commands[index + 4])!)
            let x3 = CGFloat(Double(commands[index + 5])!)
            let y3 = CGFloat(Double(commands[index + 6])!)
            result.append(.addCurve(to: remapPoint(CGPoint(x: x3, y: y3), chiHack: chiHack, width: width, height: height),
                                    control1: remapPoint(CGPoint(x: x1, y: y1), chiHack: chiHack, width: width, height: height),
                                    control2: remapPoint(CGPoint(x: x2, y: y2), chiHack: chiHack, width: width, height: height)))
            index += 7
        default:
            print("Index: ", index, "command: ", command)
            print("Unexpected command: ", command)
            fatalError("Unexpected command!")
        }
    }
    
    return result
}

fileprivate func parseMedians(_ medians: [[Double]], chiHack: Bool, width: Double, height: Double) -> [CGPoint] {
    var result: [CGPoint] = []
    for pair in medians {
        guard pair.count == 2 else {
            fatalError("Corrupted data: parseMedians")
        }
        let point = CGPoint(x: pair[0], y: pair[1])
        result.append(remapPoint(point, chiHack: chiHack, width: width, height: height))
    }
    
    return result
}

fileprivate func parseData(_ data: CharacterData, character: String, chiHack: Bool) -> TCharacter? {
    if data.medians.count != data.strokes.count {
        return nil
    }
    var strokes: [StrokeData] = []
    for idx in 0..<data.medians.count {
        let outline = parseSVGPath(data.strokes[idx], chiHack: chiHack, width: data.width ?? 1024.0, height: data.height ?? 1024.0)
        strokes.append(StrokeData(id: idx, outline: outline, medians: parseMedians(data.medians[idx], chiHack: chiHack, width: data.width ?? 1024.0, height: data.height ?? 1024.0)))
    }
    return TCharacter(character: character, strokes: strokes)
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
}

let characterHolder = CharacterHolder.load(source: "hi")
