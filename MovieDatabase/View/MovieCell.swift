//
//  MovieCell.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    var imageStr:String?
    let imageView: UIImageView = {
          let iv = UIImageView()
          iv.backgroundColor = .groupTableViewBackground
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
          return iv
      }()
      
      lazy var nameContainerView: UIView = {
          let view = UIView()
          view.backgroundColor = .mainGreen()
          return view
      }()
      
      let nameLabel: UILabel = {
          let label = UILabel()
          label.textColor = .white
          label.textAlignment = .center
          label.font = UIFont.systemFont(ofSize: 15)
          label.text = "Bulbasaur"
          label.numberOfLines  = 2
          return label
      }()
    
    override init(frame: CGRect) {
          super.init(frame: frame)
        backgroundColor = .white
          configureViewComponents()
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    func configureViewComponents(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        nameContainerView.addSubview(nameLabel)
        nameLabel.anchor(top: nameContainerView.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 0, width: 0, height: 0)
    }
    
    func setData(obj: Movie) {
         self.nameLabel.text = obj.title
             
        let posterPath:String = obj.poster_path!
        imageStr = "https://image.tmdb.org/t/p/original/\(posterPath)"
        let imageURL:URL! = URL(string: imageStr!)
               if imageStr != "" {
                   self.imageView.image = nil
                   ImageLoader.downloadImageWithUrl(url: imageURL ) { (image, imgUrl , error ) in
                    if self.imageStr == imgUrl {
                           self.imageView.image = image;
                       }
                   }
               }else {
                   imageStr = ""
                   self.imageView.image = nil
               }
    }
}
