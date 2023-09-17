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
}

struct StrokeData {
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
}

fileprivate func remapPoint(_ point: CGPoint) -> CGPoint {
    // https://github.com/skishore/makemeahanzi/tree/master#graphicstxt-keys
    return CGPoint(
        x: point.x / 1024.0,
        y: (900 - point.y) / 1024.0
    )
}

fileprivate func parseSVGPath(_ path: String) -> [StrokePathComponent] {
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
            result.append(.addQuadCurve(to: remapPoint(CGPoint(x: x2, y: y2)), control: remapPoint(CGPoint(x: x1, y: y1))))
            index += 5
        case "L":
            let x = CGFloat(Double(commands[index + 1])!)
            let y = CGFloat(Double(commands[index + 2])!)
            result.append(.addLine(to: remapPoint(CGPoint(x: x, y: y))))
            index += 3
        case "Z":
            result.append(.closeSubpath)
            index += 1
        default:
            index += 1
        }
    }
    
    return result
}

fileprivate func parseMedians(_ medians: [[Double]]) -> [CGPoint] {
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

fileprivate func parseData(_ data: CharacterData, character: String) -> TCharacter? {
    if data.medians.count != data.strokes.count {
        return nil
    }
    var strokes: [StrokeData] = []
    for idx in 0..<data.medians.count {
        strokes.append(StrokeData(outline: parseSVGPath(data.strokes[idx]), medians: parseMedians(data.medians[idx])))
    }
    return TCharacter(character: character, strokes: strokes)
}

class CharacterHolder {
    var data: [String: TCharacter]
    
    init(data: [String : TCharacter]) {
        self.data = data
    }
    
    static func load() -> CharacterHolder {
        var res: [String: TCharacter] = [:]
        let url = Bundle.main.url(forResource: "chi", withExtension: "txt")!
        let data = try! String(contentsOf: url)
        for line in data.split(separator: "\n") {
            let decoder = JSONDecoder()
            let characterData = try! decoder.decode(CharacterData.self, from: Data(line.utf8))
            res[characterData.character] = parseData(characterData, character: characterData.character)!
        }
        return CharacterHolder(data: res)
    }
}

let characterHolder = CharacterHolder.load()
