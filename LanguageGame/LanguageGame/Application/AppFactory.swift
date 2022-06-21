//
//  AppFactory.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/21/22.
//

import Foundation


class DefaultAppFactory {
    func makeGameViewController() -> GameVC {
        let repo = DefaultWordRepository()
        let fetchUseCase = DefaultFetchRandomWordUseCase(repo: repo)
        let viewModel = GameViewModel(fetchUseCase: fetchUseCase)
        let vc = GameVC(viewModel: viewModel)
        
        return vc
    }
}
