//
//  QuizViewController.swift
//  TriviaApp
//
//  Created by Selin Kayar on 12.08.24.
//

import UIKit

private enum ButtonState {
    case check
    case next
}

class QuizViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let geometricBackground = GeometricBackground()
    private let questionView = QuestionHeaderView()
    
    private var selectedIndexPath: IndexPath?
    private var buttonState: ButtonState = .check

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: QuestionTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        return tableView
    }()

    private lazy var continueButton: UIButton = {
        let button = ButtonFactory.createPressStyleButton(title: "Check", theme: PressStyleThemeFactory.gray, font: .systemFont(ofSize: 15, weight: .bold))
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleContinueButton(_:)), for: .touchUpInside)
        return button
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        if let currentQuestion = viewModel.getCurrentQuestion() {
            updateUI(with: currentQuestion)
        }
        tableView.allowsSelection = true
    }

    private func configureView() {
        view.backgroundColor = .white
        geometricBackground.addDynamicShapes(to: view)
        view.addBlur(style: .systemUltraThinMaterialLight)
    }

    private func configureLayout() {
        view.addSubviews(questionView, tableView, continueButton)
        tableView.sectionHeaderHeight = 3
        tableView.sectionFooterHeight = 3

        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            tableView.topAnchor.constraint(equalTo: questionView.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func updateUI(with question: Question) {
        questionView.configure(with: question.formattedQuestion)
        tableView.reloadData()
        
        tableView.allowsSelection = true
        updateCellsForSelectionState()
        selectedIndexPath = nil
        setButtonState(.check)
    }
    
    private func updateCellsForSelectionState() {
        guard view.window != nil else { return }
        tableView.visibleCells.forEach { cell in
            if let cell = cell as? QuestionTableViewCell {
                cell.configureForSelectionState(isSelectable: tableView.allowsSelection)
            }
        }
    }
    
    private func setButtonState(_ state: ButtonState) {
        buttonState = state
        UIView.performWithoutAnimation {
            continueButton.isEnabled = selectedIndexPath != nil
            continueButton.setPressStyle(selectedIndexPath != nil ? PressStyleThemeFactory.purple : PressStyleThemeFactory.gray)
            continueButton.setTitle(state == .check ? "Check" : "Continue", for: .normal)
            continueButton.setTitleColor(selectedIndexPath == nil ? PressStyleThemeFactory.gray.textColor : PressStyleThemeFactory.purple.textColor, for: .normal)
            continueButton.layoutIfNeeded()
        }
    }
    
    private func validateAnswer() {
        guard let selectedIndexPath = selectedIndexPath,
              let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? QuestionTableViewCell,
              let selectedAnswer = selectedCell.getLabelTitle(),
              let answers = viewModel.getCurrentQuestionAnswers() else { return }
        
        tableView.allowsSelection = false
        updateCellsForSelectionState()
        
        let isCorrect = viewModel.checkQuestionAnswer(selectedAnswer)
        updateCellAppearance(for: selectedCell, isCorrect: isCorrect, correctAnswers: answers)
        setButtonState(.next)
    }

    private func updateCellAppearance(for cell: QuestionTableViewCell, isCorrect: Bool, correctAnswers: [QuestionAnswer]) {
        let pressStyle = isCorrect ? PressStyleThemeFactory.green : PressStyleThemeFactory.red
        cell.changePressStyle(pressStyle: pressStyle)
        
        if !isCorrect {
            highlightCorrectAnswer(in: correctAnswers)
        }
    }

    private func highlightCorrectAnswer(in answers: [QuestionAnswer]) {
        guard let correctAnswer = answers.first(where: { $0.isCorrect }) else { return }
        let correctIndexPath = IndexPath(row: 0, section: answers.firstIndex(of: correctAnswer) ?? 0)
        if let correctCell = tableView.cellForRow(at: correctIndexPath) as? QuestionTableViewCell {
            correctCell.changePressStyle(pressStyle: PressStyleThemeFactory.green)
        }
    }

    @objc private func handleContinueButton(_ sender: UIButton) {
        switch buttonState {
          case .check:
              validateAnswer()
          case .next:
              if let nextQuestion = viewModel.getNextQuestion() {
                  updateUI(with: nextQuestion)
              } else {
                  // Handle the end of the quiz
              }
          }
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getCurrentQuestionAnswers()?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.reuseID, for: indexPath) as? QuestionTableViewCell else { return UITableViewCell() }
        
        guard let answers = viewModel.getCurrentQuestionAnswers() else { return UITableViewCell() }
        let answer = answers[indexPath.section]

        cell.configure(with: answer.text)
        cell.delegate = self
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        setButtonState(.check)
    }
}

extension QuizViewController: QuestionTableViewCellDelegate {
    func cellButtonPressed(in cell: QuestionTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            if let delegate = tableView.delegate {
                let _ = delegate.tableView?(tableView, willSelectRowAt: indexPath)
                delegate.tableView?(tableView, didSelectRowAt: indexPath)
            }
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
}
