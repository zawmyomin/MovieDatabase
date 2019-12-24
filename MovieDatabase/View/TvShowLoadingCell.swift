//
//  TvShowLoadingCell.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 23/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//


import UIKit

class TvShowLoadingCell: UITableViewCell {
    
    var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        indicator.color = .mainGreen()
        indicator.hidesWhenStopped = true
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])

        indicator.startAnimating()
    }
}
