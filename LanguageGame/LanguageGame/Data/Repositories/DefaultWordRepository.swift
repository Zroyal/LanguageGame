//
//  DefaultWordRepository.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation

struct DefaultWordRepository: WordRepository {
    
    func loadWords() -> [Word]? {
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Word].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

}
