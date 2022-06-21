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
    @Published var gameFinished: Bool = false
    
    private let totalQuestions = 15
    private let validWrongAttempts = 3
    
    
    init(fetchUseCase: FetchRandomWordUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func startGame() {
        currentWord = fetchUseCase?.fetchNewWord()
    }
    
    func answer(isCorrect: Bool?) {
        if isCorrect == nil {
            wrongAttempts += 1
            
        } else {
            if (currentWord?.isCorrect ?? false) == (isCorrect ?? false) {
                correctAttempts += 1
            } else {
                wrongAttempts += 1
            }
        }
        
        if wrongAttempts + correctAttempts == totalQuestions || wrongAttempts == validWrongAttempts {
            gameFinished = true
        } else {
            currentWord = fetchUseCase?.fetchNewWord()
        }
    }
    
    func getGameTime() -> Int {
        return 5
    }

    func resetGame() {
        gameFinished = false
        correctAttempts = 0
        wrongAttempts = 0
        fetchUseCase?.resetWords()
        startGame()
    }

}
