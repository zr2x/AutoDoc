//
//  WebViewController.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 15.07.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let url: URL
    private let webView = WKWebView()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(closeTapped))
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc
    private func closeTapped() {
        self.dismiss(animated: true)
    }
}
