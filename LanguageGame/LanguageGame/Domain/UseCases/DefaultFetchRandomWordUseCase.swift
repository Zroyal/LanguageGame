//
//  DefaultFetchRandomWordUseCase.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

class DefaultFetchRandomWordUseCase: FetchRandomWordUseCase {
    private var allWords: [Word] = []
    private var remainingIndexes: [Int] = []
    private var repo: WordRepository
    
    init(repo: WordRepository) {
        self.repo = repo
        
        self.allWords = repo.loadWords() ?? []
        self.resetRemainingIndexes()
    }
    
    func fetchNewWord() -> RandomWord? {
        if shouldPickCorrentAnswer() {
            if let word = pickCorrentWordPair() {
                let randomWord = RandomWord(word: word, isCorrect: true)
                return randomWord
            }
            
        } else {
            if let word = pickIncorrentWordPair() {
                let randomWord = RandomWord(word: word, isCorrect: false)
                return randomWord
            }
        }
        
        return nil
    }
    
    func resetWords() {
        self.resetRemainingIndexes()
    }
    
    private func pickCorrentWordPair() -> Word? {
        if remainingIndexes.count == 0 {
            resetRemainingIndexes()
        }
        
        if let element = remainingIndexes.randomElement() {
            if let ind = remainingIndexes.firstIndex(of: element) {
                remainingIndexes.remove(at: ind)
            }

            return allWords[element]
        }
        
        return nil
    }
    
    private func pickIncorrentWordPair() -> Word? {
        if let element1 = allWords.randomElement(), let element2 = allWords.randomElement() {
            if element1.english != element2.english {
                let newWord = Word(english: element1.english, spanish: element2.spanish)
                return newWord
            } else {
                return pickIncorrentWordPair()
            }
        }
        
        return nil
    }
    
    
    private func resetRemainingIndexes()  {
        let lastIndex = max(self.allWords.count - 1, 0)
        self.remainingIndexes = Array(0...lastIndex)
    }
    
    private func shouldPickCorrentAnswer() -> Bool {
        let array = [1,2,3,4]
        let num = array.randomElement()
        
        return num == 1
    }
}
