//
//  CardsListViewController.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

private let reuseIdentifier = "CardCell"

class CardsListViewController: UIViewController {
    
    //MARK: - Properties
    private var cards: [Card] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItem()
        setupTableView()
        loadCards()
    }
    //MARK: - HelperFunctions
    private func setupNavItem() {
        navigationItem.title = "Картки"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard)), animated: true)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadCards() {}
    
    private func saveCards() {}
    
    //MARK: - Selectors
    @objc private func addCard() {
        cards.insert(Card(type: .visa, number: "1234123412341234"), at: 0)
        
        saveCards()
        
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CardsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CardCell
        let card = cards[indexPath.row]
        cell.configure(with: card)
        return cell
    }
}
