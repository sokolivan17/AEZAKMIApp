//
//  LoadingViewController.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 07.12.2024.
//

import UIKit

class LoadingViewController: UIViewController {
    private var containerView: UIView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Reachability.isConnected() {
            presentAlert(title: NSLocalizedString("There is no Internet connection", comment: ""),
                         actionTitle: NSLocalizedString("Close", comment: ""))
        }
    }

    public func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground

        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }

    public func dismissLoadingView() {
        activityIndicator.stopAnimating()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}
