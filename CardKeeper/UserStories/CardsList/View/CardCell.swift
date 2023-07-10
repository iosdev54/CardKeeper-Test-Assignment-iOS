//
//  CardCell.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

class CardCell: UITableViewCell {
    
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: 45).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return logo
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 13
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HelperFunctions
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, numberLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with card: Card) {
        logoImageView.image = card.type.logo
        numberLabel.text = card.maskedNumber
    }
}
