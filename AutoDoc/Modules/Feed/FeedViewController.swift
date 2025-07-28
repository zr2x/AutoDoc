//
//  FeedViewController.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import UIKit
import Combine

final class FeedViewController: UIViewController {

    private let viewModel: FeedViewModelProtocol = FeedViewModelImpl()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Section: CaseIterable {
        case news
    }
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout(for: view.bounds.size)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.register(
            NewsCollectionViewCell.self,
            forCellWithReuseIdentifier: NewsCollectionViewCell.identifier
        )
        collection.register(
            FooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier
        )
        
        return collection
    }()
        
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section,NewsItems.News> = {
        let dataSource = UICollectionViewDiffableDataSource
        <Section,NewsItems.News>(
        collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else { return nil }
            cell.configure(with: item)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collection, kind, indexPath in
            if kind == UICollectionView.elementKindSectionFooter,
               indexPath.section == dataSource.snapshot().sectionIdentifiers.count - 1 {
                guard let footer = collection.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
                    for: indexPath) as? FooterLoadingCollectionReusableView else {
                    return UICollectionReusableView()
                }
                footer.startAnimating()
                return footer
            }
            return  nil
        }
        return dataSource
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setSubscribe()
        errorSubscribe()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout = self.createLayout(for: size)
        })
    }
    
    //MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        for subView in [collectionView, spinner, errorView] {
            view.addSubview(subView)
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorView.heightAnchor.constraint(equalToConstant: 200),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - Subscribe
    private func setSubscribe() {
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.spinner.stopAnimating()
                self?.updateCollection(with: items)
        }
            .store(in: &cancellables)
        
        viewModel.loadNextPage()
    }
    
    private func errorSubscribe() {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                let hasError = (error != nil)
                self?.collectionView.isHidden = hasError
                self?.spinner.isHidden = hasError
                self?.errorView.isHidden = !hasError
            }.store(in: &cancellables)
    }
    
    private func createLayout(for size: CGSize) -> UICollectionViewCompositionalLayout {
        let isLandscape = size.width > size.height
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupCount = isLandscape ? 4 : 2
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)
                ),
                repeatingSubitem: item,
                count: groupCount
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    // MARK: - Public methods
    func updateCollection(with data: [NewsItems.News]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItems.News>()
        snapshot.safelyAppendSections(Section.allCases)
        snapshot.safelyAppendItems(data, toSection: .news)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let newsItem = snapshot.itemIdentifiers(inSection: section)[indexPath.row]
        
        guard let newsUrl = newsItem.fullUrl else { return }
        let webView = WebViewController(url: newsUrl)
        let navVc = UINavigationController(rootViewController: webView)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.loadNextPage()
        }
    }
}

// MARK: - ErrorViewDelegate
extension FeedViewController: ErrorViewDelegate {
    func didTapRetry() {
        errorView.isHidden = true
        spinner.startAnimating()
        viewModel.loadNextPage()
    }
}
