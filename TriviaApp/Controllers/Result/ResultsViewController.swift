//
//  ResultsViewController.swift
//  TriviaApp
//
//  Created by Selin Kayar on 16.08.24.
//

import UIKit

class ResultsViewController: UIViewController {

    private let geometricBackground = GeometricBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
        if let confettiLayer = ConfettiUtility.createConfettiLayer(in: view) {
            view.layer.addSublayer(confettiLayer)
        }
    }
}
