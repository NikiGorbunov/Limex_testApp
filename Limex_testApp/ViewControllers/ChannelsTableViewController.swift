//
//  ChannelsTableViewController.swift
//  Limex_testApp
//
//  Created by Никита Горбунов on 30.06.2022.
//

import UIKit
import AVKit
import RealmSwift

class ChannelsTableViewController: UITableViewController {
    
    //MARK: Private properties
    private var channel: Channels?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredChannel: [Channel] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        fetchChannels(from: Link.ChannelApi.rawValue)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredChannel.count : channel?.channels.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! ChannelCell
        let channel = isFiltering
        ? filteredChannel[indexPath.row]
        : channel?.channels[indexPath.row]
        cell.configure(with: channel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = isFiltering
        ? filteredChannel[indexPath.row]
        : channel?.channels[indexPath.row]

        guard let videoURL = URL(string: currentCell?.url ?? "") else {
            showAlert(title: "Oops!", message: "Что-то пошло не так.")
            return
        }
        let player = AVPlayer(url: videoURL)

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    // MARK: - Private methods
    private func setupSearchController() {
    
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Напишите название телеканала"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    private func fetchChannels(from url: String?) {
        NetworkManager.shared.fetchChannels(from: url) { channel in
            self.channel = channel
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ChannelsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredChannel = channel?.channels.filter{ channel in
            channel.nameRu.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
    }
}

// MARK: - Show Alert
extension ChannelsTableViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}


