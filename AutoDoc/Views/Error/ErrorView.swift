//
//  ErrorView.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 28.07.2025.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTapRetry()
}

final class ErrorView: UIView {
    
    weak var delegate: ErrorViewDelegate?
    
    private let errorTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.errorText
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.retryText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .secondaryLabel
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        for view in [errorTextLabel, retryButton] {
            addSubview(view)
        }
                
        NSLayoutConstraint.activate([
            errorTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorTextLabel.topAnchor.constraint(equalTo: topAnchor),
            retryButton.topAnchor.constraint(equalTo: errorTextLabel.bottomAnchor, constant: 8),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Actions
    @objc
    private func didTapRetry() {
        delegate?.didTapRetry()
    }
}
