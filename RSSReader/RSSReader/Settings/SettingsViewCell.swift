//
//  SettingsViewCell.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 24.05.2025.
//

import Foundation
import UIKit

final class SettingsViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SettingsViewCell"
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = .systemFont(ofSize: 24)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkbox: UISwitch = {
        let box = UISwitch()
        box.translatesAutoresizingMaskIntoConstraints = false
        box.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return box
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var switchValueChanged: ((Bool) -> Void)?
    
    func configureCell(title: String) {
        backgroundColor = .clear
        titleLabel.text = title
    }
    
    func setSwitchState(_ isOn: Bool) {
        checkbox.setOn(isOn, animated: false)
    }
    
    // MARK: - Private
    
    @objc private func switchChanged() {
        switchValueChanged?(checkbox.isOn)
    }
    
    private func setupCell() {
        contentView.addSubview(container)
        
        container.addSubview(titleLabel)
        container.addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            checkbox.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            checkbox.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}
