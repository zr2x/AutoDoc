//
//  FooterLoadingCollectionReusableView.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 16.07.2025.
//

import UIKit

final class FooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "FooterLoadingCollectionReusableView"
    
    private let spiner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        NSLayoutConstraint.activate([
            spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func startAnimating() {
        spiner.startAnimating()
    }
}
