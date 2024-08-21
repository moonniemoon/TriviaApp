//
//  QuestionResponse.swift
//  TriviaApp
//
//  Created by Selin Kayar on 8.08.24.
//

import Foundation

struct QuestionResponse: Codable {
    let responseCode: Int
    let results: [Question]
}
