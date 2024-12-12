//
//  CountryViewModel.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 05.12.2024.
//

import UIKit

struct CountryModel: Hashable {
    let flag: String
    let continents: String
    let currencies: String
    let languages: String
    let officialName: String
    let latitude: Double
    let longitude: Double
    let area: Double
    let population: Int
    let timezones: String
    let flagsUrlString: String
    let capital: String
}

final class CountriesViewModel {
    var reloadTableView: (()->())?
    var showError: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    
    private var isSearching = false
    private var baseViewModels: [CountryModel] = []
    private var filteredViewModels: [CountryModel] = [CountryModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    public var numberOfCells: Int {
        return filteredViewModels.count
    }
    
    public func getData() {
        showLoading?()
        NetworkManager.shared.loadCountries { [weak self] result in
            guard let self else { return }
            self.hideLoading?()
            
            switch result {
            case .success(let countries):
                self.filteredViewModels = getMappedModel(countries: countries)
                self.baseViewModels = getMappedModel(countries: countries)
                self.reloadTableView?()
                
                print(numberOfCells)
            case .failure(_):
                self.showError?()
            }
        }
    }
    
    public func getDataFromDB() {
        showLoading?()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let countries = CoreDataManager.shared.getAllItems()
            self.filteredViewModels = getMappedModelFromDB(countries: countries)
            self.baseViewModels = getMappedModelFromDB(countries: countries)
            self.hideLoading?()
        }
    }
    
    public func loadFlagImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        NetworkManager.shared.downloadImage(from: urlString, completed: completed)
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> CountryModel {
        return filteredViewModels[indexPath.row]
    }
    
    public func addCountryToDB(with model: CountryModel, completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            CoreDataManager.shared.createItem(with: model, completion: completion)
        }
        
    }
    
    public func removeCell(at indexPath: IndexPath) {
        filteredViewModels.remove(at: indexPath.row)
        DispatchQueue.main.async {
            CoreDataManager.shared.deleteItem(at: indexPath.row)
        }
    }
    
    public func updateUI(for text: String, completion: () -> Void) {
        guard !text.isEmpty else {
            filteredViewModels = baseViewModels
            completion()
            isSearching = false
            return
        }

        isSearching = true
        filteredViewModels = baseViewModels.filter { $0.officialName.lowercased().contains(text.lowercased())
        }
        completion()
    }
    
    private func getMappedModel(countries: [Country]) -> [CountryModel] {
        countries.map({ model in
            
            let flag = model.flag
            let continents = model.continents.joined(separator: ", ")
            let currencies = model.currencies?.map { $0.value.name + " - " + $0.value.symbol }.joined(separator: ", ") ?? ""
            let languages = model.languages?.map { $0.value }.joined(separator: ", ") ?? ""
            let officialName = model.translations[NSLocalizedString("name", comment: "")]?.official ?? ""
            let latitude = model.latlng.first ?? 0.0
            let longitude = model.latlng.last ?? 0.0
            let area = model.area
            let population = model.population
            let timezones = model.timezones.joined(separator: ", ")
            let flagsUrlString = model.flags.png
            let capital = model.capital?.joined(separator: ", ") ?? ""
            
            return CountryModel(flag: flag,
                                 continents: continents,
                                 currencies: currencies,
                                 languages: languages,
                                 officialName: officialName,
                                 latitude: latitude,
                                 longitude: longitude,
                                 area: area,
                                 population: population,
                                 timezones: timezones,
                                 flagsUrlString: flagsUrlString,
                                 capital: capital)
        })
    }
    
    private func getMappedModelFromDB(countries: [DBCountryModel]) -> [CountryModel] {
        return countries.map({ model in
            
            let flag = model.flag
            let continents = model.continents
            let currencies = model.currencies
            let languages = model.languages
            let officialName = model.officialName
            let latitude = model.latitude
            let longitude = model.longitude
            let area = model.area
            let population = Int(model.population)
            let timezones = model.timezones
            let flagsUrlString = model.flagsUrlString
            let capital = model.capital
            
            return CountryModel(flag: flag,
                                 continents: continents,
                                 currencies: currencies,
                                 languages: languages,
                                 officialName: officialName,
                                 latitude: latitude,
                                 longitude: longitude,
                                 area: area,
                                 population: population,
                                 timezones: timezones,
                                 flagsUrlString: flagsUrlString,
                                 capital: capital)
        })
    }
    
}
