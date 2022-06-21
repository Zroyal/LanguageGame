//
//  ViewModelTest.swift
//  LanguageGameTests
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import XCTest
import Combine
@testable import LanguageGame

class ViewModelTest: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
    }

    func testStartGame() throws {
        let repo = MockWordReposiory()
        let usecase = DefaultFetchRandomWordUseCase(repo: repo)
        
        let sut = GameViewModel(fetchUseCase: usecase)
        
        let expectation = self.expectation(description: "testStartGame")

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.startGame()
        
        waitForExpectations(timeout: 2)

        XCTAssertNotNil(sut.currentWord, "current word is nil")
        XCTAssertNotNil(sut.currentWord?.english, "english phrase of current word is nil")
        XCTAssertNotNil(sut.currentWord?.spanish, "spanish phrase of current word is nil")
        XCTAssertNotNil(sut.currentWord?.isCorrect, "isCorrect flag of current word is nil")
    }

    func testWrongAttemptsCounter() throws {
        let repo = MockWordReposiory()
        let usecase = DefaultFetchRandomWordUseCase(repo: repo)
    
        let sut = GameViewModel(fetchUseCase: usecase)
        
        sut.startGame()

        var word: RandomWord?
        
        let expectation = self.expectation(description: "testWrongAttemptsCounter")

        sut.$wrongAttempts.sink(receiveValue: { value in
            if value > 0 {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if word == nil {
                word = value
                DispatchQueue.main.async {
                    sut.answer(isCorrect: !(word?.isCorrect ?? false))
                }
            }
        }).store(in: &cancellables)

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.wrongAttempts == 1)
    }

    
    func testCorrectAttemptsCounter() throws {
        let repo = MockWordReposiory()
        let usecase = DefaultFetchRandomWordUseCase(repo: repo)
    
        let sut = GameViewModel(fetchUseCase: usecase)
        
        sut.startGame()

        var word: RandomWord?
        
        let expectation = self.expectation(description: "testCorrectAttemptsCounter")

        sut.$correctAttempts.sink(receiveValue: { value in
            if value > 0 {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if word == nil {
                word = value
                DispatchQueue.main.async {
                    sut.answer(isCorrect: word?.isCorrect ?? false)
                }
            }
        }).store(in: &cancellables)

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.correctAttempts == 1)
    }

    func testGameFinishedWithWrongTry() throws {
        let repo = MockWordReposiory()
        let usecase = DefaultFetchRandomWordUseCase(repo: repo)
    
        let sut = GameViewModel(fetchUseCase: usecase)
                
        let expectation = self.expectation(description: "testGameFinishedWithWrongTry")

        sut.$gameFinished.sink(receiveValue: { value in
            if value == true {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                DispatchQueue.main.async {
                    sut.answer(isCorrect: !(value?.isCorrect ?? false))
                }
            }
        })
        .store(in: &cancellables)

        sut.startGame()

        waitForExpectations(timeout: 2)

        XCTAssertTrue(sut.wrongAttempts == 3)
    }

    func testGameFinishedWithCorrectTry() throws {
        let repo = MockWordReposiory()
        let usecase = DefaultFetchRandomWordUseCase(repo: repo)
    
        let sut = GameViewModel(fetchUseCase: usecase)
                
        let expectation = self.expectation(description: "testGameFinishedWithCorrectTry")

        sut.$gameFinished.sink(receiveValue: { value in
            if value == true {
                expectation.fulfill()
            }
        }).store(in: &cancellables)

        sut.$currentWord.sink(receiveValue: { value in
            if value != nil {
                DispatchQueue.main.async {
                    sut.answer(isCorrect: sut.currentWord?.isCorrect ?? false)
                }
            }
        }).store(in: &cancellables)

        sut.startGame()

        waitForExpectations(timeout: 5)

        XCTAssertTrue(sut.correctAttempts == 15, "\(sut.correctAttempts)")
    }

}
