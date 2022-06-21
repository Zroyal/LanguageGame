//
//  GameViewModel.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation
import Combine

class GameViewModel {
    private var fetchUseCase: FetchRandomWordUseCase?
    
    @Published var currentWord: RandomWord?
    @Published var correctAttempts: Int = 0
    @Published var wrongAttempts: Int = 0
    
    
    init(fetchUseCase: FetchRandomWordUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func startGame() {
        currentWord = fetchUseCase?.fetchNewWord()
    }
    
    func answer(isCorrect: Bool) {
        if (currentWord?.isCorrect ?? false) == isCorrect {
            correctAttempts += 1
        } else {
            wrongAttempts += 1
        }
        
        currentWord = fetchUseCase?.fetchNewWord()
    }
}
