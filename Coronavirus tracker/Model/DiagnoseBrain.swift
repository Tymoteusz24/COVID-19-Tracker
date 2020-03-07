//
//  DiagnoseBrain.swift
//  Coronavirus tracker
//
//  Created by Tymoteusz Pasieka on 01/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation


struct DiagnoseBrain {
    let questions = [Question(question: NSLocalizedString("Have you recently traveled to a country where there were coronavirus cases?", comment: "Have you recently traveled to a country where there were coronavirus cases?"), percent: 30), Question(question: NSLocalizedString("Have you had contact with a person with coronavirus?", comment: "Have you had contact with a person with coronavirus?"), percent: 50), Question(question: NSLocalizedString("Do you have a high fever?", comment: "Do you have a high fever?"), percent: 5), Question(question: NSLocalizedString("Do you have a cough?", comment: "Do you have a cough?"), percent: 5), Question(question: NSLocalizedString("Do you have shortness of breath or shallow breathing?", comment: "Do you have shortness of breath or shallow breathing?"), percent: 5)]
    
    var diagnoseScore = 0
    var currentQuestion = 0
    var startedDiagnose = false
    
    var currentQuestionText: String {
        return questions[currentQuestion].question
    }
    var currentQuestionPercent: Int {
        return questions[currentQuestion].percent
    }
    
    mutating func startDiagnose(_ start: Bool) {
        if start {
            currentQuestion = 0
            diagnoseScore = 0
        }
        startedDiagnose = start
    }
    
    
    mutating func nextQuestion() -> Int? {
        if currentQuestion < questions.count - 1 {
            currentQuestion += 1
            return nil
        } else {
            startDiagnose(false)
            return diagnoseScore
        }
    }
    
    mutating func updateScore(by number: Int) {
        diagnoseScore += number
    }
    
}
