//
//  UseCaseTest.swift
//  LanguageGameTests
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import XCTest
@testable import LanguageGame

class UseCaseTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testFetch() throws {
        let repo = MockWordReposiory()
        let sut = DefaultFetchRandomWordUseCase(repo: repo)
        
        if let word = sut.fetchNewWord() {
            if word.isCorrect {
                var canFind = false
                for item in repo.loadWords() ?? [] {
                    if word.spanish == item.spanish && word.english == item.english {
                        canFind = true
                        break
                    }
                }
                
                XCTAssert(canFind)
                
            } else {
                var canFind = false
                for item in repo.loadWords() ?? [] {
                    if word.spanish == item.spanish && word.english == item.english {
                        canFind = true
                        break
                    }
                }
                
                XCTAssert(!canFind)
            }
            
        } else {
            XCTFail("error fetching word")
        }
    }

}
