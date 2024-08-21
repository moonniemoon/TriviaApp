//
//  QuestionTableViewCell.swift
//  TriviaApp
//
//  Created by Selin Kayar on 12.08.24.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: QuestionTableViewCell.self)
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .natural
        label.textColor = Colors.labelLight
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelBackground: UIView = {
        let view = UIView()
        view.setPressStyle(PressStyleThemeFactory.outlinedDark)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(labelBackground)
        labelBackground.addSubview(label)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.attributedText = nil
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            labelBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            label.topAnchor.constraint(equalTo: labelBackground.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: labelBackground.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: labelBackground.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: labelBackground.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with title: NSAttributedString) {
        label.attributedText = title
        layoutIfNeeded()
    }
}
