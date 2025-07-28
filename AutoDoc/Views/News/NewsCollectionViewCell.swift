//
//  NewsCollectionViewCell.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsCollectionViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishedNewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let categoryNewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        for view in [newsTitleLabel,
            newsDescriptionLabel,
            publishedNewsLabel,
            newsImageView,
            categoryNewsLabel]
        {
            contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            newsImageView.widthAnchor.constraint(equalToConstant: 80),
            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor),
            
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            publishedNewsLabel.leadingAnchor.constraint(equalTo: newsTitleLabel.leadingAnchor),
            publishedNewsLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 4),
            
            categoryNewsLabel.leadingAnchor.constraint(equalTo: publishedNewsLabel.trailingAnchor, constant: 8),
            categoryNewsLabel.centerYAnchor.constraint(equalTo: publishedNewsLabel.centerYAnchor),
            categoryNewsLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            
            newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            newsDescriptionLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 12),
            newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            newsDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDescriptionLabel.text = nil
        publishedNewsLabel.text = nil
        categoryNewsLabel.text = nil
        newsImageView.image = nil
    }
    
    public func configure(with model: NewsItems.News) {
        newsTitleLabel.text = model.title
        newsDescriptionLabel.text = model.description
        publishedNewsLabel.text = model.publishedDate?.dateWithTimeFormatted
        categoryNewsLabel.text = model.categoryType
        
        
        if let url = model.titleImageUrl {
            Task {
                do {
                    let imageData = try await ImageLoader.shared.downloadImage(url)
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: imageData)
                    }
                }
                catch {
                    self.newsImageView.image = UIImage(systemName: "photo")
                }
            }
        }
    }
}
