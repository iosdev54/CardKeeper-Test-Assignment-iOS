//
//  CardsListViewController.swift
//  CardKeeper
//
//  Created by Dmytro Grytsenko on 10.07.2023.
//

import UIKit

final class CardsListViewController: UIViewController {
    
    //MARK: - Properties
    private var cards: [Card] = [] {
        didSet {
            tableView.allowsSelection = cards.isEmpty ? false : true
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let reuseIdentifierCard = "CardCell"
    private let reuseIdentifierNoCard = "NoCardCell"
    
    private var keychainKey: String {
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
        return "\(bundleIdentifier).savedCards"
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
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
        tableView.register(CardCell.self, forCellReuseIdentifier: reuseIdentifierCard)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifierNoCard)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadCards() {
        do {
            cards = try KeychainManager.load(key: keychainKey)
        } catch KeychainManager.KeychainError.loadFailed(let status) {
            print("DEBUG: Failed to load cards from Keychain: \(status)")
        } catch {
            print("DEBUG: Failed to load cards: \(error)")
        }
        
        cards.sort { $0.dateAdded > $1.dateAdded }
        
        tableView.reloadData()
    }
    
    private func saveCards() {
        do {
            try KeychainManager.save(key: keychainKey, cards: cards)
        } catch KeychainManager.KeychainError.saveFailed(let status) {
            print("DEBUG: Failed to save cards to Keychain: \(status)")
        } catch {
            print("DEBUG: Failed to save cards: \(error)")
        }
    }
    
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
        return cards.isEmpty ? 1 : cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cards.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierNoCard, for: indexPath)
            cell.textLabel?.text = "No cards, click add to add them"
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .red.withAlphaComponent(0.2)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCard, for: indexPath) as! CardCell
            let card = cards[indexPath.row]
            cell.configure(with: card)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !cards.isEmpty else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let card = cards[indexPath.row]
        let cardDetailsViewController = CardDetailsViewController(card: card)
        navigationController?.pushViewController(cardDetailsViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !cards.isEmpty else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            self?.cards.remove(at: indexPath.row)
            self?.saveCards()
            
            if self?.cards.isEmpty == true {
                tableView.reloadData()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completionHandler(true)
        }
        deleteAction.image = UIImage.AppImages.trash
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
}
