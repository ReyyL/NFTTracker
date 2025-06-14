//
//  CoinViewController.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 26.04.2025.
//

import UIKit

protocol ICoinViewController: AnyObject {
    func updateView()
    func showLoader()
}

final class CoinViewController: UIViewController, ICoinViewController {
    
    private let presenter: ICoinPresenter
    private var isLoading = false
    
    weak var delegate: SettingsDelegate?
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .black
        loader.center = view.center
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "gearshape")!, target: self, action: #selector(setFilters))
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: ICoinPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var emptyTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.text = "Вы не выбрали монеты"
        title.font = .systemFont(ofSize: 24)
        return title
    }()
    
    private lazy var emptyCoinsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        buildView()
        presenter.viewDidLoad()
    }
    
    func showLoader() {
        if !isLoading {
            isLoading = true
            loader.startAnimating()
        }
    }
    
    func hideLoader() {
        if isLoading {
            isLoading = false
            loader.stopAnimating()
        }
    }
    
    func updateView() {
        hideLoader()
        refreshControl.endRefreshing()
        
        if let coins = presenter.coins, coins.isEmpty {
            tableView.isHidden = true
            emptyCoinsView.isHidden = false
            buildEmptyView()
        } else {
            tableView.isHidden = false
            emptyCoinsView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    @objc private func setFilters() {
        let presenter = SettingsPresenter()
        let controller = SettingsViewController(presenter: presenter)
        
        presenter.view = controller
        controller.delegate = self
        navigationController?.present(controller, animated: true)
    }
    
    @objc private func handlePullToRefresh() {
        presenter.viewDidLoad()
        hideLoader()
    }
    
    private func buildEmptyView() {
        view.addSubview(emptyCoinsView)
        emptyCoinsView.addSubview(emptyTitle)
        
        NSLayoutConstraint.activate([
            emptyCoinsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyCoinsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyCoinsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyCoinsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyTitle.centerXAnchor.constraint(equalTo: emptyCoinsView.centerXAnchor),
            emptyTitle.centerYAnchor.constraint(equalTo: emptyCoinsView.centerYAnchor)
        ])
    }
    
    private func buildView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        tableView.refreshControl = refreshControl
        view.addSubview(tableView)
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CoinViewController: SettingsDelegate {
    func didUpdateSettings(selectedCoins: [String]) {
        delegate?.didUpdateSettings(selectedCoins: selectedCoins)
        presenter.viewDidLoad()
        updateView()
    }
}

// MARK: - UITableView

extension CoinViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CoinTableViewCell,
              let coins = presenter.coins else {
            return UITableViewCell()
        }
        
        let coin = coins[indexPath.section]
        cell.configureCell(model: coin)
        return cell
    }
}

extension CoinViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
