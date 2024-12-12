//
//  DetailViewController.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 07.12.2024.
//

import UIKit
import MapKit

final class DetailViewController: LoadingViewController {
    
    fileprivate class Point: NSObject, MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D

        init(title: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
        }
    }
    
    private lazy var officialNameLabel = UILabel()
    private lazy var capitalNameLabel = UILabel()
    private lazy var populationLabel = UILabel()
    private lazy var areaLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var languagesLabel = UILabel()
    private lazy var timezonesLabel = UILabel()
    private let coordinatesView = MKMapView()
    private let flagView = UIImageView()
    private let starButton = UIButton()
    
    private let viewModel = CountriesViewModel()
    
    private var model: CountryModel
    
    init(with model: CountryModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.showLoadingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        setupNavigationBar()
        loadFlagImage()
        loadLocation()
        setupUI()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(shareButtonTapped))
        let starItem = UIBarButtonItem(customView: starButton)
        navigationItem.rightBarButtonItems = [shareItem, starItem]
    }
    
    private func setupUI() {
        officialNameLabel = CountryLabel(with: model.officialName, size: 18, weight: .bold)
        capitalNameLabel = CountryLabel(with: NSLocalizedString("Capital", comment: "") +
                                        ": " + model.capital)
        populationLabel = CountryLabel(with: NSLocalizedString("Population", comment: "") + ": " +
                                       "\(model.population) " +
                                       NSLocalizedString("People", comment: "").lowercased())
        areaLabel = CountryLabel(with: NSLocalizedString("Area", comment: "") + ": " +
                                 "\(model.area) " + NSLocalizedString("km^2", comment: ""))
        currencyLabel = CountryLabel(with: NSLocalizedString("Currency", comment: "") + ": " + model.currencies)
        languagesLabel = CountryLabel(with: NSLocalizedString("Language", comment: "") + ": " + model.languages)
        timezonesLabel = CountryLabel(with: NSLocalizedString("Time zone", comment: "") + ": " + model.timezones)
        
        coordinatesView.layer.cornerRadius = 5
        coordinatesView.clipsToBounds = true
        
        flagView.layer.cornerRadius = 5
        flagView.clipsToBounds = true
        
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
    }
    
    private func loadLocation() {
        let annotation = Point(title: model.officialName,
                               coordinate: CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude))
        let location = CLLocation(latitude: model.latitude, longitude: model.longitude)
        
        coordinatesView.addAnnotation(annotation)
        coordinatesView.centerToLocation(location)
    }
    
    private func loadFlagImage() {
        if Reachability.isConnected() {
            viewModel.loadFlagImage(from: model.flagsUrlString) { [weak self] image in
                guard let self else { return }
                self.dismissLoadingView()
                self.flagView.image = image
            }
        }
    }
    
    private func setupLayout() {
        let views = [
            officialNameLabel,
            capitalNameLabel,
            populationLabel,
            areaLabel,
            currencyLabel,
            languagesLabel,
            timezonesLabel,
            coordinatesView,
            flagView
        ]
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            officialNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            officialNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            officialNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            capitalNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            capitalNameLabel.topAnchor.constraint(equalTo: officialNameLabel.bottomAnchor, constant: 8),
            capitalNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            populationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            populationLabel.topAnchor.constraint(equalTo: capitalNameLabel.bottomAnchor, constant: 8),
            populationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            areaLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            areaLabel.topAnchor.constraint(equalTo: populationLabel.bottomAnchor, constant: 8),
            areaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            currencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            currencyLabel.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 8),
            currencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
    
            languagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            languagesLabel.topAnchor.constraint(equalTo: currencyLabel.bottomAnchor, constant: 8),
            languagesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            timezonesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            timezonesLabel.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 8),
            timezonesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            coordinatesView.topAnchor.constraint(equalTo: timezonesLabel.bottomAnchor, constant: 8),
            coordinatesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            coordinatesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            coordinatesView.heightAnchor.constraint(equalToConstant: 200),
            
            flagView.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 8),
            flagView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            flagView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            flagView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func addToFavorite() {
        viewModel.addCountryToDB(with: model) { [weak self] title in
            guard let self else { return }
            self.presentAlert(title: title,
                              actionTitle: NSLocalizedString("Close", comment: ""))
        }
    }
    
    @objc private func shareButtonTapped() {
        let sharedString = 
        NSLocalizedString("Capital", comment: "") + ": " + model.capital + "\n" +
        NSLocalizedString("Population", comment: "") + ": " + "\(model.population) " +
        NSLocalizedString("People", comment: "").lowercased() + "\n" +
        NSLocalizedString("Area", comment: "") + ": " + "\(model.area) " +
        NSLocalizedString("km^2", comment: "") + "\n" +
        NSLocalizedString("Currency", comment: "") + ": " + model.currencies + "\n" +
        NSLocalizedString("Language", comment: "") + ": " + model.languages + "\n" +
        NSLocalizedString("Time zone", comment: "") + ": " + model.timezones
        
        let item = [sharedString]
        let activityController = UIActivityViewController(activityItems: item, applicationActivities: nil)
        present(activityController, animated: true)
    }
}
