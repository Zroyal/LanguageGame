//
//  WordRepository.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

protocol WordRepository {
    func loadWords() -> [Word]?
}
