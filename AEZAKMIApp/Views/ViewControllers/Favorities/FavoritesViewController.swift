//
//  FavoritesViewController.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 11.12.2024.
//

import UIKit

final class FavoritesViewController: BaseListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Favorites", comment: "")
        initViewModel()
    }
    
    private func initViewModel() {
        viewModel.showError = { [weak self] in
            self?.presentAlert(title: NSLocalizedString("Loading eror", comment: ""),
                               message: NSLocalizedString("Repeat the loading attempt", comment: ""),
                               actionTitle: NSLocalizedString("Ok", comment: "")) { _ in
                self?.viewModel.getDataFromDB()
            }
        }
        
        viewModel.getDataFromDB()
    }
}

extension FavoritesViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCell(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
