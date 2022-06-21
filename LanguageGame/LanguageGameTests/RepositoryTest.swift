//
//  RepositoryTest.swift
//  LanguageGameTests
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import XCTest
@testable import LanguageGame

class RepositoryTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLoadWords() throws {
        let sut = DefaultWordRepository()
        let words = sut.loadWords()
        
        XCTAssert(words?.count == 297)
        
        let randomWord = words?.randomElement()
        XCTAssert(randomWord?.spanish.count ?? 0 > 0)
        XCTAssert(randomWord?.english.count ?? 0 > 0)
    }

}
