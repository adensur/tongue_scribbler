//
//  CharacterView.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import SwiftUI

fileprivate func scalePoint(_ point: CGPoint, scale: Double) -> CGPoint {
    return CGPoint(x: point.x * scale, y: point.y * scale)
}

struct TCharacterOutlineShape : Shape {
    var character: TCharacter
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let scaleFactor = min(width, height)
        for stroke in character.strokes {
            for component in stroke.outline {
                switch component {
                case .move(let to):
                    path.move(to: scalePoint(to, scale: scaleFactor))
                case .addQuadCurve(let to, let control):
                    path.addQuadCurve(to: scalePoint(to, scale: scaleFactor), control: scalePoint(control, scale: scaleFactor))
                case .addCurve(let to, let control1, let control2):
                    path.addCurve(to: scalePoint(to, scale: scaleFactor), control1: scalePoint(control1, scale: scaleFactor), control2: scalePoint(control2, scale: scaleFactor))
                case .addLine(let to):
                    path.addLine(to: scalePoint(to, scale: scaleFactor))
                case .closeSubpath:
                    path.closeSubpath()
                }
            }
        }
        return path
    }
}


struct CharacterView: View {
    var character: TCharacter
    var body: some View {
        TCharacterOutlineShape(character: character)
            .fill(.black)
            .frame(width: 256, height: 256)
    }
}

#Preview {
    CharacterView(character: characterHolder.data["我"]!)
}
