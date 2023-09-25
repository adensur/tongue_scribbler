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

func normalizeAngle(_ angle: Angle) -> Angle {
    var angle = angle
    if angle.radians > .pi / 2.0 {
        angle.radians -= .pi
    }
    if angle.radians < -.pi / 2.0 {
        angle.radians += .pi
    }
    return angle
}

fileprivate func processPathComponents(components: [StrokePathComponent], scaleFactor: Double, path: inout Path) {
    print("processPathComponents\n\n")
    for component in components {
        print("Component: ", component)
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
            ()
            path.closeSubpath()
        case .Arc(radiusX: let radiusX, radiusY: let radiusY, rotation: let rotation, largeArc: let largeArc, sweep: let sweep, to: let to):
            let to = scalePoint(to, scale: scaleFactor)
            let startPoint = path.currentPoint!
            let radius = radiusX * scaleFactor
            print("radius: ", radius)
            let centers = findArcCenter(start: startPoint, end: to, radius: radius)!
            print("Centers: ", centers)
            // choose proper center depending on the current quarter
            //
            let quarter = getQuarter(startPoint, to)
            let center: CGPoint
            if quarter == .first || quarter == .second {
                center = sweep ? centers.1 : centers.0
            } else {
                center = sweep ? centers.0 : centers.1
            }
            let startAngle = Angle(degrees: atan2(startPoint.y - center.y, startPoint.x - center.x) * 180 / .pi)
            let endAngle = Angle(degrees: atan2(to.y - center.y, to.x - center.x) * 180 / .pi)
            print("Original start/end angle, sweep: ", startAngle, endAngle, sweep)
            print("Start point \(startPoint), end point \(to), center: \(center)")
            var clockwise = !sweep
            if largeArc {
                clockwise.toggle()
            }
            print("Normalised start/end angle: ", startAngle, endAngle)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            
//            path.move(to: to)
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

class QuizDataModel: ObservableObject {
    @Published var character: TCharacter
    @Published var showOutline: Bool
    @Published var canvasEnabled: Bool
    @Published var currentMatchingIdx = 0
    @Published var drawProgress: [Double] = []
    var onSuccess: () -> Void
    init(character: TCharacter, showOutline: Bool = true, canvasEnabled: Bool = true, onSuccess: @escaping () -> Void) {
        self.character = character
        self.showOutline = showOutline
        self.canvasEnabled = canvasEnabled
        self.onSuccess = onSuccess
    }
    
    func animateStrokes() {
        print("Data model animate strokes called!")
        let oldProgress = drawProgress
        for idx in 0..<drawProgress.count {
            drawProgress[idx] = 0.0
        }
        var delay = 0.3
        for idx in 0..<character.strokes.count {
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                drawProgress[idx] = 1.0
            }
            delay += 0.8
        }
        // return to initial state
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.drawProgress = oldProgress
        }
    }
    
    func resetProgress() {
        currentMatchingIdx = 0
        drawProgress = character.strokes.map {_ in
            return 0.0
        }
    }
}

struct QuizCharacterView : View {
    @ObservedObject var dataModel: QuizDataModel
    // use state for cache. Do not observe changes
    @State private var userStrokes = UserStrokes()
    @State private var failsInARow = 0
    @State private var matchFinishedFlash = false
    
    func outlineColour(idx: Int) -> Color {
        if matchFinishedFlash {
            return .blue
        }
        if dataModel.currentMatchingIdx > idx {
            return .black
        }
        if dataModel.showOutline {
            return .gray
        }
        return .white.opacity(.zero)
    }
    var body: some View {
        GeometryReader {proxy in
            VStack {
                let size = min(proxy.size.width, proxy.size.height)
                ZStack {
                    // use reversed range so that strokes drawn first are on the top
                    // StrokeOutline - the actual drawing of a character
                    ForEach((0..<dataModel.character.strokes.count).reversed(), id: \.self) {idx in
                        TStrokeOutlineShape(outline: dataModel.character.strokes[idx].outline)
                            .fill(outlineColour(idx: idx))
                    }
                    // simple stroke along the character stroke.
                    // since its masked by the outline, it looks good enough
                    if dataModel.canvasEnabled && dataModel.drawProgress.count > 0 {
                        ForEach(0..<dataModel.drawProgress.count, id: \.self) {idx in
                            if idx < dataModel.character.strokes.count {
                                TStrokeShape(medians: dataModel.character.strokes[idx].medians)
                                    .trim(to: dataModel.drawProgress[idx])
                                    .stroke(.blue.opacity(0.7), style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .miter))
                                    .mask {
                                        TStrokeOutlineShape(outline: dataModel.character.strokes[idx].outline)
                                    }
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
                                if strokesMatch(userStroke: scalePoints(userStrokes.strokes.last!.points, scale: 1 / size), characterStroke: dataModel.character.strokes[dataModel.currentMatchingIdx].medians) {
                                    failsInARow = 0
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        dataModel.currentMatchingIdx += 1
                                    }
                                    if dataModel.currentMatchingIdx == dataModel.character.strokes.count {
                                        withAnimation(.easeInOut(duration: 0.3).delay(0.5)) {
                                            matchFinishedFlash = true
                                        }
                                        withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
                                            matchFinishedFlash = false
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            dataModel.onSuccess()
                                        }
                                    }
                                } else {
                                    // trigger stroke animation after N successive failures
                                    failsInARow += 1
                                    if failsInARow >= 3 {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            dataModel.drawProgress[dataModel.currentMatchingIdx] = 1.0
                                        }
                                        withAnimation(.easeInOut(duration: 0.05).delay(0.6)) {
                                            dataModel.drawProgress[dataModel.currentMatchingIdx] = 0.0
                                        }
                                    }
                                }
                                userStrokes.strokes.append(.init())
                            }
                        )
                    }
                }
            }
        }
        .onAppear {
            dataModel.drawProgress = dataModel.character.strokes.map {_ in
                return 0.0
            }
        }
    }
}

#Preview {
    CharacterView(character: characterHolder.data["अ"]!)
}
