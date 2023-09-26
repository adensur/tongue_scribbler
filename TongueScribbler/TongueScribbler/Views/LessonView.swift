//
//  LessonView.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 25/09/2023.
//

import SwiftUI

struct QuizOptions {
    let character: String
    let showOutline: Bool
}

enum ELessonStage {
    case characterQuiz(quizOptions: QuizOptions)
    case quizDemo(quizOptions: QuizOptions)
    case lessonText(lessonText: String)
}

let stages: [ELessonStage] = [
    .lessonText(lessonText: "Sample lesson text"),
    .quizDemo(quizOptions: .init(character: "अ", showOutline: true)),
    .characterQuiz(quizOptions: .init(character: "अ", showOutline: true)),
    .characterQuiz(quizOptions: .init(character: "आ", showOutline: true)),
    .quizDemo(quizOptions: .init(character: "अ", showOutline: false)),
    .characterQuiz(quizOptions: .init(character: "अ", showOutline: false)),
    .characterQuiz(quizOptions: .init(character: "आ", showOutline: false))
    ]

struct LessonView: View {
    let lessonStages: [ELessonStage]
    @State private var lessonStage: ELessonStage = .lessonText(lessonText: "")
    @ObservedObject var dataModel = QuizDataModel(character: characterHolder.data["अ"]!) { }
    @State private var idx = 0
    var body: some View {
        VStack {
            if idx < lessonStages.count {
                switch lessonStage {
                case .characterQuiz(let quizOptions):
                    QuizCharacterView(dataModel: dataModel)
                        .frame(width: 256, height: 256)
                case .quizDemo(let quizOptions):
                    VStack {
                        AnimatableCharacterView(character: dataModel.character, showOutline: dataModel.showOutline)
                            .frame(width: 256, height: 256)
                        Text("This is the demo for quiz view")
                            .padding()
                        Button("Next") {
                            idx += 1
                            processDataModel()
                        }
                    }
                case .lessonText(let lessonText):
                    Text(lessonText)
                    Button("Next") {
                        idx += 1
                        processDataModel()
                    }
                }
            } else {
                Text("Success!")
            }
        }
        .onAppear {
            processDataModel()
        }
    }
    
    func processDataModel() {
        guard idx < lessonStages.count else {
            return
        }
        lessonStage = lessonStages[idx]
        switch lessonStage {
        case .characterQuiz(let quizOptions):
            dataModel.character = characterHolder.data[quizOptions.character]!
            dataModel.resetProgress()
            dataModel.showOutline = quizOptions.showOutline
            dataModel.canvasEnabled = true
        case .quizDemo(let quizOptions):
            dataModel.character = characterHolder.data[quizOptions.character]!
            dataModel.resetProgress()
            dataModel.showOutline = quizOptions.showOutline
            dataModel.canvasEnabled = false
            dataModel.animateStrokes()
        case .lessonText(let lessonText):
            ()
        }
        dataModel.onSuccess = {
            idx += 1
            processDataModel()
        }
    }
}

#Preview {
    LessonView(lessonStages: stages)
}
