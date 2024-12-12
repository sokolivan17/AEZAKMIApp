//
//  BaseListViewController.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 12.12.2024.
//

import UIKit

class BaseListViewController: LoadingViewController {
   
    private let tableView = UITableView()
    public let viewModel = CountriesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupLayout()
        configureSearchController()
        initViewModel()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("Enter the name of the country", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func initViewModel() {
        viewModel.reloadTableView = { [weak self] in
            self?.updateData()
        }
        
        viewModel.showLoading = { [weak self] in
            self?.showLoadingView()
        }
        viewModel.hideLoading = { [weak self] in
            self?.dismissLoadingView()
        }
    }
    
    private func updateData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension BaseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as! CountryTableViewCell
        let model = viewModel.getCellViewModel(at: indexPath)
        cell.configuire(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getCellViewModel(at: indexPath)
        let viewController = DetailViewController(with: model)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
}


extension BaseListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        viewModel.updateUI(for: filter) {
            updateData()
        }
    }
}

