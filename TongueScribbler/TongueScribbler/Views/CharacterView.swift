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

fileprivate func scalePoints(_ points: [CGPoint], scale: Double) -> [CGPoint] {
    return points.map {point in
        return scalePoint(point, scale: scale)
    }
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
    @State private var outlineIsSolid = true
    @State private var drawProgress: [Double] = []
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
                // return to initial state
                outlineIsSolid = true
                drawProgress = character.strokes.map {_ in
                    return 0.0
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

struct Particle {
    var position: CGPoint
    let deathDate = Date.now.timeIntervalSinceReferenceDate + 1.0
}

class UserStroke {
    var particles: [Particle] = []
    var points: [CGPoint] = []
    func addPoint(_ point: CGPoint) {
        particles.append(.init(position: point))
        points.append(point)
    }
    func update(date: TimeInterval) {
        particles = particles.filter { $0.deathDate > date }
    }
}

class UserStrokes {
    var strokes: [UserStroke] = [.init()]
    func update(date: TimeInterval) {
        var toRemove = IndexSet()
        for (index, stroke) in strokes.enumerated() {
            stroke.update(date: date)
            if index != strokes.indices.last! && stroke.particles.isEmpty {
                toRemove.insert(index)
            }
        }
        strokes.remove(atOffsets: toRemove)
    }
}

struct QuizCharacterView : View {
    let character: TCharacter
    var userStrokes = UserStrokes()
    @State private var currentMatchingIdx = 0
    @State private var allMatched = false
    @State private var failsInARow = 0
    @State private var drawProgress = 0.0
    @State private var showOutline = true
    
    func outlineColour(idx: Int) -> Color {
        if currentMatchingIdx > idx {
            return .black
        }
        if showOutline {
            return .gray
        }
        return .white.opacity(0)
    }
    
    var body: some View {
        VStack {
            GeometryReader {proxy in
                let size = min(proxy.size.width, proxy.size.height)
                ZStack {
                    // use reversed range so that strokes drawn first are on the top
                    ForEach((0..<character.strokes.count).reversed(), id: \.self) {idx in
                        TStrokeOutlineShape(outline: character.strokes[idx].outline)
                            .fill(outlineColour(idx: idx))
                    }
                    if currentMatchingIdx < character.strokes.count {
                        TStrokeShape(medians: character.strokes[currentMatchingIdx].medians)
                            .trim(to: drawProgress)
                            .stroke(.blue.opacity(0.7), style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .miter))
                            .mask {
                                TStrokeOutlineShape(outline: character.strokes[currentMatchingIdx].outline)
                            }
                    }
                    TimelineView(.animation) {timeline in
                        Canvas {ctx, size in
                            let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                            userStrokes.update(date: timelineDate)
                            ctx.blendMode = .plusLighter
                            ctx.addFilter(.blur(radius: 3))
                            ctx.addFilter(.alphaThreshold(min: 0.3, color: .black))
                            for stroke in userStrokes.strokes {
                                var path = Path()
                                if let first = stroke.particles.first {
                                    path.move(to: first.position)
                                    for particle in stroke.particles.dropFirst() {
                                        ctx.opacity = (particle.deathDate - timelineDate) * 1.5
                                        path.addLine(to: particle.position)
                                        ctx.stroke(path, with: .color(.black), lineWidth: 10)
                                        path = Path()
                                        path.move(to: particle.position)
                                    }
                                }
                            }
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged {drag in
                            if let stroke = userStrokes.strokes.last {
                                stroke.addPoint(drag.location)
                            }
                        }
                        .onEnded {drag in
                            // match the previous stroke
                            if !allMatched {
                                if strokesMatch(userStroke: scalePoints(userStrokes.strokes.last!.points, scale: 1 / size), characterStroke: character.strokes[currentMatchingIdx].medians) {
                                    failsInARow = 0
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        currentMatchingIdx += 1
                                    }
                                    if currentMatchingIdx == character.strokes.count {
                                        allMatched = true
                                    }
                                } else {
                                    // trigger stroke animation after N successive failures
                                    failsInARow += 1
                                    if failsInARow >= 3 {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            drawProgress = 1.0
                                        }
                                        withAnimation(.easeInOut(duration: 0.05).delay(0.6)) {
                                            drawProgress = 0
                                        }
                                    }
                                }
                            }
                            userStrokes.strokes.append(.init())
                        }
                    )
                }
                .frame(width: size, height: size)
                .border(.gray)
            }
            
            Toggle(isOn: $showOutline) {
                Text("Show Outline")
            }
            Button("Reset") {
                currentMatchingIdx = 0
                allMatched = false
            }
        }
    }
}

#Preview {
    CharacterView(character: characterHolder.data["我"]!)
}
