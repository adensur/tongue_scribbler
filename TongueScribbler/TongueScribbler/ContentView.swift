//
//  ContentView.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import SwiftUI

struct MedianPath: Shape {
    let arrayOfPairs: [[[Int]]] = [
        [[458,627],[392,631],[336,588],[274,552],[258,550],[253,542],[220,530],[212,532],[203,522]],
        [[174,404],[215,398],[241,402],[672,514],[742,512]],
        [[323,556],[351,542],[365,522],[361,116],[340,67],[246,113]],
        [[100,206],[124,195],[163,189],[492,334]],
        [[492,807],[537,760],[538,627],[569,435],[612,299],[676,170],[717,112],[779,48],[817,22],[859,12],[880,78],[891,140],[886,147],[894,173]],
        [[723,412],[737,365],[664,259],[594,198],[489,142],[454,132]],
        [[657,710],[750,668],[781,634]]
    ]
    
    func convert(_ val: Int) -> Double {
        return Double(val) / 1024.0
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        for stroke in arrayOfPairs {
            let first = stroke.first!
            path.move(to: CGPoint(x: convert(first[0]) * width, y: height-convert(first[1]) * height))
            for point in stroke.dropFirst() {
                path.addLine(to: CGPoint(x: convert(point[0]) * width, y: height-convert(point[1]) * height))
            }
        }
        return path
    }
}

struct ContentView: View {
    @State private var drawProgress = 1.0
    var body: some View {
        VStack {
            CharacterView(character: characterHolder.data["我"]!)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
