//
//  CountryTableViewCell.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 07.12.2024.
//

import UIKit

final class CountryTableViewCell: UITableViewCell {

    static var identifier: String {
        return try! Configuration.value(for: "CELL_IDENTIFIER")
    }
    
    private let countryName = UILabel()
    private let region = UILabel()
    private let flag = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        countryName.numberOfLines = 0
        countryName.font = .systemFont(ofSize: 18)
        
        region.font = .systemFont(ofSize: 16)
        
        flag.font = .systemFont(ofSize: 28)
        flag.textAlignment = .center
    }
    
    private func setupLayout() {
        addSubview(countryName)
        addSubview(region)
        addSubview(flag)
        
        countryName.translatesAutoresizingMaskIntoConstraints = false
        region.translatesAutoresizingMaskIntoConstraints = false
        flag.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            countryName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            countryName.trailingAnchor.constraint(equalTo: flag.leadingAnchor, constant: -8),
            
            region.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            region.topAnchor.constraint(equalTo: countryName.bottomAnchor, constant: 8),
            region.trailingAnchor.constraint(equalTo: flag.leadingAnchor, constant: -8),
            region.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            flag.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            flag.widthAnchor.constraint(equalToConstant: 30),
            flag.heightAnchor.constraint(equalToConstant: 30),
            flag.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func configuire(with model: CountryModel) {
        countryName.text = model.officialName
        region.text = model.continents
        flag.text = model.flag
    }
}
