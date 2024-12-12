//
//  CountryLabel.swift
//  AEZAKMIApp
//
//  Created by Ваня Сокол on 12.12.2024.
//

import UIKit

final class CountryLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with textLabel: String,
                     size: CGFloat = 16,
                     weight: UIFont.Weight = .regular) {
        self.init(frame: .zero)
        text = textLabel
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    private func configure() {
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
