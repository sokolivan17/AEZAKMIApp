//
//  CountriesViewController.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 05.12.2024.
//

import UIKit

final class CountriesViewController: BaseListViewController {

    private let favoritesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        initViewModel()
        setupFavoritiesButton()
    }

    private func initViewModel() {
        viewModel.showError = { [weak self] in
            self?.presentAlert(title: NSLocalizedString("Loading eror", comment: ""),
                               message: NSLocalizedString("Repeat the loading attempt", comment: ""),
                               actionTitle: NSLocalizedString("Ok", comment: "")) { _ in
                self?.viewModel.getData()
            }
        }
        
        viewModel.getData()
    }
    
    private func setupFavoritiesButton() {
        favoritesButton.setTitle(NSLocalizedString("Favorites", comment: ""), for: .normal)
        favoritesButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        favoritesButton.titleLabel?.font = .systemFont(ofSize: 16)
        favoritesButton.setTitleColor(.systemBlue, for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
    }
    
    @objc private func favoritesButtonTapped() {
        let viewController = FavoritesViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
