//
//  FetchRandomWordUseCase.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

protocol FetchRandomWordUseCase {
    func fetchNewWord() -> RandomWord?
    func resetWords()
}
