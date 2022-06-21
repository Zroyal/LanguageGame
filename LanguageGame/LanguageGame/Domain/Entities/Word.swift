//
//  Word.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

struct Word : Codable {
    var english: String
    var spanish: String
    
    enum CodingKeys : String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
}
