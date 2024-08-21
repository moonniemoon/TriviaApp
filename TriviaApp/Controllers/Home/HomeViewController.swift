//
//  HomeViewController.swift
//  TriviaApp
//
//  Created by Selin Kayar on 3.08.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let geometricBackground = GeometricBackground()
    private let difficultyInputView = DifficultyInputView()
    private let logoView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "triviaWorldLogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var categoryButton = ButtonFactory.createPressStyleButton(title: "Any Category", theme: PressStyleThemeFactory.outlinedDark, font: .systemFont(ofSize: 13, weight: .semibold))
    
    private lazy var startButton: UIButton = {
        let button = ButtonFactory.createPressStyleButton(title: "Start Quiz", theme: PressStyleThemeFactory.purple, font: .systemFont(ofSize: 14, weight: .heavy))
        button.addTarget(self, action: #selector(handleStartButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [categoryButton, difficultyInputView, startButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCategoryButtonMenu()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.geometricBackground.removeShapes()
            self?.geometricBackground.addDynamicShapes(to: self?.view ?? UIView())
        })
    }
    
    private func configureView() {
        view.backgroundColor = .white
        geometricBackground.addDynamicShapes(to: view)
        view.addBlur(style: .systemUltraThinMaterialLight)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureLayout() {
        view.addSubviews(logoView, vStackView)
        difficultyInputView.delegate = self
        difficultyInputView.setButtonHeight(height: 45)
        
        [categoryButton, startButton].forEach({
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        })

        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 3.0/5.0),
            
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.58),
        ])
    }
    
    private func configureCategoryButtonMenu() {
        //Task {
            //await viewModel.loadCategories()
            
            let anyCategoryOption = UIAction(title: "Any Category") { [weak self] _ in
                self?.viewModel.setCategory(nil)
                self?.categoryButton.setTitle("Any Category", for: .normal)
            }
            
            MenuConfigurator.addMenu(
                to: categoryButton,
                with: viewModel.getCategories(),
                heading: "Categories",
                createMenuItem: { [weak self] category in
                    UIAction(title: category.name) { [weak self] _ in
                        self?.viewModel.setCategory(category)
                        self?.categoryButton.setTitle(category.name, for: .normal)
                    }
                },
                additionalOptions: [anyCategoryOption]
            )
        //}
    }
    
    @objc private func handleStartButtonAction(_ sender: UIButton) {
        Task {
            await viewModel.loadQuestions()
            
            // loading view here?
            
            // dispatch main the controller? 
            let controller = QuizViewController(viewModel: viewModel)
            navigationController?.pushViewController(controller, animated: false)
        }
        
        // loading view here?
        
//        let controllerr = QuizViewController(question: Question(type: .multiple, difficulty: .medium, category: "Entertainment: Film", question: "In &quot;Sonic Adventure&quot;, you are able to transform into Super Sonic at will after completing the main story.", correctAnswer: "Human ewfokeoiwfrkwoerfkoewrkewrkpeowrkewrkwepokrowpekroewrkpoewkropkrpokerkepowkepowkTorch", incorrectAnswers: ["Cyclerijhreuiguirhehguirhriutherops", "Iceman", "Daredevil"]))
//        navigationController?.pushViewController(controllerr, animated: false)
    }
}

extension HomeViewController: DifficultyInputViewDelegate {
    func difficultyInputView(_ view: DifficultyInputView, didSelectDifficulty difficulty: QuestionDifficulty) {
        viewModel.setDifficulty(difficulty)
    }
}
