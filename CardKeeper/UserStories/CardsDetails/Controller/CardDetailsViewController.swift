//
//  CardDetailsViewController.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    //MARK: - Properties
    let card: Card
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = card.type.color
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    private let bankLabel: UILabel = {
        let label = UILabel()
        label.text = "Bank"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = card.type.logo
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return imageView
    }()
    
    private lazy var maskedNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "**** \(card.number.suffix(4))"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = card.type == .mastercard ? .lightGray : .darkGray
        return label
    }()
    
    private var cardSize: CGSize {
        let width: CGFloat = 400
        return CGSize(width: width, height: width / 1.6)
    }
    
    //MARK: - Lifecycle
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = maskedNumberLabel.text
        
        setupCardView()
    }
    
    //MARK: - HelperFunctions
    private func setupCardView() {
        view.addSubview(cardView)
        
        let leadingConstraint = cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        leadingConstraint.priority = .defaultHigh
        
        let trailingConstraint = cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        trailingConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cardView.widthAnchor.constraint(lessThanOrEqualToConstant: cardSize.width),
            cardView.heightAnchor.constraint(equalToConstant: cardSize.height),
            leadingConstraint,
            trailingConstraint
        ])
        
        let horizontalStack = UIStackView(arrangedSubviews: [maskedNumberLabel, logoImageView])
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 20
        horizontalStack.alignment = .fill
        
        let mainStack = UIStackView(arrangedSubviews: [bankLabel, horizontalStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .leading
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 25),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -25),
            mainStack.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 25),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -25),
            horizontalStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor)
        ])
    }
}
