//
//  LoadingCells.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 23/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//


import UIKit

class LoadingCells: UICollectionViewCell {
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        
          setupSubviews()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    private func setupSubviews() {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        indicator.color = .mainGreen()
        indicator.hidesWhenStopped = true
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15)
            ])

        indicator.startAnimating()
    }
    
}
