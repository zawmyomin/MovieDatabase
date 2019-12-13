//
//  TVCell.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {
    
    var imageStr:String?

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        setupView()
    }
    
    func setupView(){
        backgroundColor = .clear
        lblTitle.textColor = .white
        lblTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lblTitle.backgroundColor = .mainGreen()
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 6
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = .clear
        
        imgView.clipsToBounds = true
        imgView.backgroundColor = .clear
        
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 2]
        gradientLayer.opacity = 4//0.6
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setUpShadow() {
           self.layer.shadowOpacity = 0.18
           self.layer.shadowOffset = CGSize(width: 0, height: 2)
           self.layer.shadowRadius = 2
           self.layer.shadowColor = UIColor.black.cgColor
           self.layer.masksToBounds = false
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(obj: Movie) {
        
        let requiretext: String = obj.original_name!
        self.lblTitle.text = "  " + requiretext//obj.original_name

//      let posterPath:String = obj.poster_path!
//      imageStr = "https://image.tmdb.org/t/p/original/\(posterPath)"
        let backdrop_path:String = obj.backdrop_path!

        imageStr = "https://image.tmdb.org/t/p/original/\(backdrop_path)"
    
        let imageURL:URL! = URL(string: imageStr!)
                
        if imageStr != "" {
            self.imgView.image = nil
            ImageLoader.downloadImageWithUrl(url: imageURL ) { (image, imgUrl , error ) in
                if self.imageStr == imgUrl {
                    self.imgView.image = image;
                }
            }
        }else {
            imageStr = ""
            self.imgView.image = nil
        }
        
     }
    
}


