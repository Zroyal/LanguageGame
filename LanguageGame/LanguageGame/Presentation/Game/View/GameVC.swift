//
//  GameVC.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/20/22.
//

import UIKit
import Combine

class GameVC: UIViewController {

    private let viewModel: GameViewModel
    private var bindings = Set<AnyCancellable>()

    private var corretLabel = UILabel(frame: .zero)
    private var wrongLabel = UILabel(frame: .zero)

    private var wordLabel = UILabel(frame: .zero)
    private var translationLabel = UILabel(frame: .zero)

    private var correctButton = UIButton(frame: .zero)
    private var wrongButton = UIButton(frame: .zero)

    private var topStack = UIStackView(frame: .zero)
    private var bottomStack = UIStackView(frame: .zero)

    private var timerLabel = UILabel(frame: .zero)

    private let margin: CGFloat = 16.0
    
    private var translationTopConstraint: NSLayoutConstraint?
    private var startTranslationLocation: CGFloat = 0
    private var endTranslationLocation: CGFloat = 0

    private var animator: UIViewPropertyAnimator?

    @Published private var secondsRemaining = 0
    private var timer: Timer?

    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startGame()
    }
    
    private func configView() {
        self.view.backgroundColor = .white

        makeTimerLabel()
        makeAttemptLabels()
        makeTranslationRelatedLabels()
        makeButtons()
        
        self.view.layoutIfNeeded()
        
        startTranslationLocation = topStack.frame.maxY + corretLabel.frame.height + wrongLabel.frame.height
        endTranslationLocation = bottomStack.frame.origin.y - wrongButton.frame.height - margin

    }

    private func makeTimerLabel() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textColor = .darkGray
        timerLabel.font = .systemFont(ofSize: 14.0)
        timerLabel.layer.cornerRadius = 12.0
        timerLabel.layer.masksToBounds = true
        timerLabel.backgroundColor = .systemGroupedBackground
        timerLabel.text = "0"
        timerLabel.textAlignment = .center

        view.addSubview(timerLabel)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: margin),
                        
            timerLabel.topAnchor.constraint(
                equalTo: margins.topAnchor,
                constant: margin),
            
            timerLabel.widthAnchor.constraint(equalToConstant: 24.0),
            
            timerLabel.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }

    private func makeAttemptLabels() {
        topStack.axis = NSLayoutConstraint.Axis.vertical
        topStack.spacing = 8.0
        topStack.translatesAutoresizingMaskIntoConstraints = false

        corretLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLabel.translatesAutoresizingMaskIntoConstraints = false

        corretLabel.textColor = .black
        makeAnswerLabel(score: 0, isCorrect: true)
        corretLabel.textAlignment = .right
        corretLabel.font = .systemFont(ofSize: 14.0)
        topStack.addArrangedSubview(corretLabel)

        wrongLabel.textColor = .black
        makeAnswerLabel(score: 0, isCorrect: false)
        wrongLabel.textAlignment = .right
        wrongLabel.font = .systemFont(ofSize: 14.0)
        topStack.addArrangedSubview(wrongLabel)
        
        view.addSubview(topStack)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            topStack.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 0),
            
            topStack.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -margin),
            
            topStack.topAnchor.constraint(
                equalTo: margins.topAnchor,
                constant: margin),
        ])
    }

    private func makeTranslationRelatedLabels() {
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        translationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wordLabel.textColor = .black
        wordLabel.text = "word"
        wordLabel.numberOfLines = 0
        wordLabel.textAlignment = .center
        wordLabel.font = .systemFont(ofSize: 20.0, weight: .semibold)
        self.view.addSubview(wordLabel)

        translationLabel.isHidden = true
        translationLabel.textColor = .black
        translationLabel.text = "translate"
        translationLabel.textAlignment = .center
        translationLabel.numberOfLines = 0
        translationLabel.font = .systemFont(ofSize: 18.0)
        self.view.addSubview(translationLabel)
        
        translationTopConstraint = NSLayoutConstraint(
            item: self.translationLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .top,
            multiplier: 1,
            constant: startTranslationLocation)

        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: margin),
            
            wordLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -margin),
            
            wordLabel.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor,
                constant: -margin),
            
            translationLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: margin),
            
            translationLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -margin),
            
            translationTopConstraint!
        ])
    }
    
    private func makeButtons() {
        bottomStack.axis = NSLayoutConstraint.Axis.horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = margin
        
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        correctButton.translatesAutoresizingMaskIntoConstraints = false
        wrongButton.translatesAutoresizingMaskIntoConstraints = false

        correctButton.setTitle(NSLocalizedString("correct", comment: "correct"), for: .normal)
        correctButton.setTitleColor(.green, for: .normal)
        correctButton.layer.cornerRadius = 5.0
        correctButton.layer.masksToBounds = true
        correctButton.layer.borderColor = UIColor.green.cgColor
        correctButton.layer.borderWidth = 1.5
        correctButton.addTarget(self, action: #selector(correctTapped), for: .touchUpInside)
        bottomStack.addArrangedSubview(correctButton)

        wrongButton.setTitle(NSLocalizedString("wrong", comment: "wrong"), for: .normal)
        wrongButton.setTitleColor(.red, for: .normal)
        wrongButton.layer.cornerRadius = 5.0
        wrongButton.layer.masksToBounds = true
        wrongButton.layer.borderColor = UIColor.red.cgColor
        wrongButton.layer.borderWidth = 1.5
        wrongButton.addTarget(self, action: #selector(wrongTapped), for: .touchUpInside)
        bottomStack.addArrangedSubview(wrongButton)

        view.addSubview(bottomStack)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: 40.0),
            
            bottomStack.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 2*margin),
            
            bottomStack.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -2*margin),
            
            bottomStack.bottomAnchor.constraint(
                equalTo: margins.bottomAnchor,
                constant: -margin),
        ])
    }
    
    private func setupBindings() {

        viewModel.$correctAttempts
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] correctAttempts in
                self?.makeAnswerLabel(score: correctAttempts, isCorrect: true)
            })
            .store(in: &bindings)

        viewModel.$wrongAttempts
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] wrongAttempts in
                self?.makeAnswerLabel(score: wrongAttempts, isCorrect: false)
            })
            .store(in: &bindings)

        viewModel.$currentWord
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] currentWord in
                if currentWord != nil {
                    self?.setWord(currentWord)
                }
            })
            .store(in: &bindings)

        viewModel.$gameFinished
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] gameFinished in
                if gameFinished {
                    self?.timer?.invalidate()
                    self?.showEndDialogue()
                }
            })
            .store(in: &bindings)
        
        self.$secondsRemaining
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] remaining in
                self?.timerLabel.text = "\(remaining)"
            })
            .store(in: &bindings)


    }
    
    private func makeAnswerLabel(score: Int, isCorrect: Bool) {
        if isCorrect {
            self.corretLabel.text = "\(NSLocalizedString("correctAttempts", comment: "correctAttempts")): \(score)"
        } else {
            self.wrongLabel.text = "\(NSLocalizedString("wrongAttempts", comment: "wrongAttempts")): \(score)"
        }
    }

    private func setWord(_ word: RandomWord?) {
        translationLabel.text = word?.spanish
        wordLabel.text = word?.english
        startTimer()
        startAnimating()
    }
    
    private func startTimer() {
        secondsRemaining = viewModel.getGameTime()
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }

    private func reset() {
        translationLabel.isHidden = true
        translationTopConstraint!.constant = self.startTranslationLocation
        self.view.layoutIfNeeded()
    }
    
    private func startAnimating() {
        animator?.stopAnimation(true)

        animator = UIViewPropertyAnimator(duration: 5.0, curve: .easeInOut) {
            self.translationLabel.isHidden = false
            self.translationTopConstraint!.constant = self.endTranslationLocation
            self.view.layoutIfNeeded()
        }

        animator?.addCompletion { _ in
            self.reset()
            self.viewModel.answer(isCorrect: nil)
        }
        
        animator?.startAnimation()
    }

    
    // MARK: - Selectors
    
    @objc private func correctTapped() {
        animator?.stopAnimation(true)
        reset()
        viewModel.answer(isCorrect: true)
    }

    @objc private func wrongTapped() {
        animator?.stopAnimation(true)
        reset()
        viewModel.answer(isCorrect: false)
    }

    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            secondsRemaining = viewModel.getGameTime()
            timer?.invalidate()
            self.viewModel.answer(isCorrect: nil)
        }
    }

    @objc private func showEndDialogue() {
        let message = "\(NSLocalizedString("yourScore", comment: "yourScore")): \(viewModel.correctAttempts)"
        
        let title = NSLocalizedString("gameFinished", comment: "gameFinished")
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let restartString = NSLocalizedString("restart", comment: "restart")
        let restart = UIAlertAction(title: restartString, style: .default) { _ in
            self.reset()
            self.viewModel.resetGame()
        }

        let quitString = NSLocalizedString("quit", comment: "quit")
        let quit = UIAlertAction(title: quitString, style: .destructive) { _ in
            exit(0)
        }

        alert.addAction(restart)
        alert.addAction(quit)
        
        self.present(alert, animated: true)
    }

}

