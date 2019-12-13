//
//  MovieDetailController.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {
    
    var obj:Movie? = nil
    var isComeFromTV = false
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill//.scaleAspectFill
        iv.backgroundColor = .darkGray
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .mainGreen()
        label.numberOfLines = 2
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        label.textColor = .lightText//.mainGreen()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var  backButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("Back", for: .normal)
        button.setImage(UIImage(named: "backBtn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.titleLabel?.textColor = .mainGreen()
        button.addTarget(self , action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike(){
        print("Go back......")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setData()
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        configureViewComponents()
        setData()

    }
    
    func setData(){
        if isComeFromTV{
            infoLabel.text = obj?.original_name
           
        }else{
            infoLabel.text = obj?.title
            
        }
        descLabel.text = obj?.overview
//        let posterPath:String = obj!.poster_path!
        let backdrop_path:String = obj!.backdrop_path!
        let imageStr = "https://image.tmdb.org/t/p/original/\(backdrop_path)"
        let imageURL:URL! = URL(string: imageStr)
        if imageStr != "" {
            self.imageView.image = nil
            ImageLoader.downloadImageWithUrl(url: imageURL ) { (image, imgUrl , error ) in
                if imageStr == imgUrl {
                    self.imageView.image = image;
                }
            }
        }
    }
    
    func configureViewComponents(){
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.tintColor = .white
        tabBarController?.tabBar.isHidden = true
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(descLabel)
        descLabel.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
    }
}
