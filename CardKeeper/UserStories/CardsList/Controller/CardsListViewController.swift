//
//  CardsListViewController.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

class CardsListViewController: UIViewController {
    
    //MARK: - Properties
    private var cards: [Card] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let reuseIdentifier = "CardCell"
    
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
        guard let randomCardType = CardType.allCases.randomElement() else {
            return
        }
        
        let randomCardNumber = (1...16)
            .map { _ in Int.random(in: 0...9) }
            .map { String($0) }
            .joined()
        
        cards.insert(Card(type: randomCardType, number: randomCardNumber), at: 0)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let card = cards[indexPath.row]
        let cardDetailsViewController = CardDetailsViewController(card: card)
        navigationController?.pushViewController(cardDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Видалити") { [weak self] action, view, completionHandler in
            self?.cards.remove(at: indexPath.row)
            self?.saveCards()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = UIImage.AppImages.trash
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
}
