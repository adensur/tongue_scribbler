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

fileprivate func processPathComponents(components: [StrokePathComponent], scaleFactor: Double, path: inout Path) {
    for component in components {
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

struct TCharacterOutlineShape : Shape {
    var character: TCharacter
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let scaleFactor = min(width, height)
        for stroke in character.strokes {
            processPathComponents(components: stroke.outline, scaleFactor: scaleFactor, path: &path)
        }
        return path
    }
}

struct TStrokeShape: Shape {
    var medians: [CGPoint]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let scaleFactor = min(width, height)
        if let first = medians.first {
            path.move(to: scalePoint(first, scale: scaleFactor))
            for point in medians.dropFirst() {
                path.addLine(to: scalePoint(point, scale: scaleFactor))
            }
        }
        return path
    }
}

struct TStrokeOutlineShape: Shape {
    var outline: [StrokePathComponent]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        let scaleFactor = min(width, height)
        processPathComponents(components: outline, scaleFactor: scaleFactor, path: &path)
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

struct AnimatableCharacterView: View {
    let character: TCharacter
    @State var outlineIsSolid = true
    @State var drawProgress: [Double] = []
    var body: some View {
        VStack {
            ZStack {
                TCharacterOutlineShape(character: character)
                    .fill(outlineIsSolid ? .black : .gray)
                ForEach(0..<drawProgress.count, id: \.self) {idx in
                    TStrokeShape(medians: character.strokes[idx].medians)
                        .trim(to: drawProgress[idx])
                        .stroke(.black, style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .miter))
                        .mask {
                            TStrokeOutlineShape(outline: character.strokes[idx].outline)
                                .fill(.black)
                        }
                }
            }
            Button("Animate!") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    outlineIsSolid = false
                }
                for idx in 0..<drawProgress.count {
                    withAnimation(.easeInOut(duration: 0.5).delay(0.3 + (Double(idx) + 1.0) * 0.8)) {
                        drawProgress[idx] = 1.0
                    }
                }
            }
        }
        .onAppear {
            drawProgress = character.strokes.map {_ in
                return 0.0
            }
        }
    }
}

#Preview {
    CharacterView(character: characterHolder.data["我"]!)
}
