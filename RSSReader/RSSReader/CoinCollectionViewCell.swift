//
//  CoinTableViewCell.swift
//  RSSReader
//
//  Created by Andrey Lazarev on 06.05.2025.
//

import UIKit

final class CoinTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CoinTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = .systemFont(ofSize: 24)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var priceLabel: UILabel = {
        let price = UILabel()
        price.textColor = .black
        price.font = .systemFont(ofSize: 18)
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    private lazy var changePriceLabel: UILabel = {
        let change = UILabel()
        change.font = .systemFont(ofSize: 25)
        change.translatesAutoresizingMaskIntoConstraints = false
        return change
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: CryptoItem) {
        titleLabel.text = model.name.capitalized
        priceLabel.text = "$\(model.coin.usd)"
        changePriceLabel.text = String(format: "%.2f%%", model.coin.usd24hChange)
        
        changePriceLabel.textColor = model.coin.usd24hChange >= 0 ? .systemGreen : .systemRed
    }
    
    // MARK: - Private
    
    private func setupCell() {
        backgroundColor = .clear
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(priceLabel)
        container.addSubview(changePriceLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            
            priceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            
            changePriceLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            changePriceLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
    }
}
