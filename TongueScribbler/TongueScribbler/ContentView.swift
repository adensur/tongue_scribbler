//
//  ContentView.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import SwiftUI


struct ArcPath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let scaleWidth = 70.6
        func scale(_ d: Double) -> Double {
            return d * width / scaleWidth
        }
        path.move(to: CGPoint(x: 0, y: 0))
        
//        let startPoint = CGPoint(x: 40.79, y: 139.78)
        let startPoint = path.currentPoint!
        let to = CGPoint(x: scale(35), y: scale(35))
        let radius = 138.51
        let sweep = false
        let largeArc = false
        let centers = findArcCenter(start: startPoint, end: to, radius: radius)!
        print("centers: ", centers)
        let quarter = getQuarter(startPoint, to)
        let center: CGPoint
        if quarter == .first || quarter == .second {
            center = sweep ? centers.1 : centers.0
        } else {
            center = sweep ? centers.0 : centers.1
        }
        var startAngle = Angle(degrees: atan2(startPoint.y - center.y, startPoint.x - center.x) * 180 / .pi)
        var endAngle = Angle(degrees: atan2(to.y - center.y, to.x - center.x) * 180 / .pi)
        print("Original start/end angle, sweep: ", startAngle, endAngle, sweep)
        print("Start point \(startPoint), end point \(to), center: \(center)")
        let minAngle = min(startAngle, endAngle)
        let maxAngle = max(startAngle, endAngle)
        if maxAngle.radians - minAngle.radians <= .pi {
            if largeArc {
                startAngle = maxAngle
                endAngle = minAngle
            } else {
                startAngle = minAngle
                endAngle = maxAngle
            }
        } else {
            if largeArc {
                startAngle = minAngle
                endAngle = maxAngle
            } else {
                startAngle = maxAngle
                endAngle = minAngle
            }
        }
        print("Normalised start/end angle: ", startAngle, endAngle)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: scale(0), y: scale(35)))
        path.closeSubpath()
        return path
    }
}

struct MyLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
//        let height = rect.size.height
        let scaleWidth = 70.6
//        let scaleHeight = 70.6
        func scale(_ d: Double) -> Double {
            return d * width / scaleWidth
        }
        let start = CGPoint(x: scale(41.12), y: scale(39.66))
        path.move(to: start)
        let end = CGPoint(x: scale(41.2), y: scale(41.3))
        path.addLine(to: end)
        return path
    }
}

struct QuizControllerView : View {
    var body: some View {
        Text("Hello world!")
    }
}

struct ContentView: View {
    let characters = ["अ", "आ", "ए", "ऐ"]
    @State private var idx = 0
    @ObservedObject var dataModel = QuizDataModel(character: characterHolder.data["अ"]!) {
    }
    var body: some View {
//        LessonView(lessonStages: stages)
        HStack {
//            AnimatableCharacterView(character: characterHolder.data["我"]!)
            CharacterView(character: characterHolder.data["अ"]!)
                .frame(width: 128, height: 128)
            CharacterView(character: characterHolder.data["ओ"]!)
                .frame(width: 128, height: 128)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
