//
//  Question.swift
//  TriviaApp
//
//  Created by Selin Kayar on 7.08.24.
//

import Foundation

struct Question: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
//    enum CodingKeys: String, CodingKey {
//        case type
//        case difficulty
//        case category
//        case question
//        case correctAnswer = "correct_answer"
//        case incorrectAnswers = "incorrect_answers"
//    }
    
    var allAnswers: [String] {
        return (incorrectAnswers + [correctAnswer]).shuffled()
    }
}

enum QuestionType: String, Codable {
    case boolean
    case multiple
}

enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
}
