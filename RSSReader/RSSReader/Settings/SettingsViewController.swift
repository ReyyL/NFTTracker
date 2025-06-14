//
//  SettingsViewController.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 24.05.2025.
//

import Foundation
import UIKit

protocol SettingsDelegate: AnyObject {
    func didUpdateSettings(selectedCoins: [String])
}

protocol ISettingsView {
    func setCoins()
}

final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsDelegate?
    
    private let presenter: ISettingsPresenter
    
    private var selectedCoins: Set<Int> = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SettingsViewCell.self,
            forCellReuseIdentifier: SettingsViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 13
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: ISettingsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSavedCoins()
        buildSettings()
    }
    
    // MARK: - ISettingsView
    
    func setCoins() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    @objc private func saveSettings() {
        let selectedCoinNames = selectedCoins.map { presenter.coins[$0] }
        UserDefaults.standard.set(selectedCoinNames, forKey: "selectedCoins")
        delegate?.didUpdateSettings(selectedCoins: selectedCoinNames)
        dismiss(animated: true, completion: nil)
    }
    
    private func setSavedCoins() {
        if let savedCoins = UserDefaults.standard.stringArray(
            forKey: "selectedCoins")
        {
            for (index, coin) in presenter.coins.enumerated() {
                if savedCoins.contains(coin) {
                    selectedCoins.insert(index)
                }
            }
        }
    }
    
    private func buildSettings() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        NSLayoutConstraint.activate([
            
            saveButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            saveButton.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int {
        presenter.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsViewCell.reuseIdentifier,
            for: indexPath
        ) as? SettingsViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configureCell(title: presenter.coins[indexPath.row])
        
        let isSelected = selectedCoins.contains(indexPath.row)
        cell.setSwitchState(isSelected)
        
        cell.switchValueChanged = { [weak self] isOn in
            if isOn {
                self?.selectedCoins.insert(indexPath.row)
            } else {
                self?.selectedCoins.remove(indexPath.row)
            }
        }
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        120
    }
}
