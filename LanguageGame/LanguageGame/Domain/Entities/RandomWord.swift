//
//  RandomWord.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

struct RandomWord {
    var english: String
    var spanish: String
    var isCorrect: Bool
    
    init(word: Word, isCorrect: Bool) {
        self.english = word.english
        self.spanish = word.spanish
        self.isCorrect = isCorrect
    }
}
