//
//  MainTabBarController.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 30/11/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupViewControllers()
    }
    
    func setupViewControllers(){
        
        
        let layOut = UICollectionViewFlowLayout()
        let navMovie = UINavigationController(rootViewController: MovieController(collectionViewLayout: layOut))
        navMovie.tabBarItem.image = UIImage(named: "movie")
        navMovie.tabBarItem.selectedImage = UIImage(named: "movieFill")
        navMovie.title = "MOVIE"

        let tvShowController = TvShowController()
        let navTvShow = UINavigationController(rootViewController: tvShowController)
        navTvShow.tabBarItem.image = UIImage(named: "tshow")
        navTvShow.tabBarItem.selectedImage = UIImage(named: "tshowfill")
        navTvShow.title = "TV SHOW"
        
        
        viewControllers = [navMovie,navTvShow]
        tabBar.tintColor = .mainGreen()
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 14, right: 0)
        }
    }
    
    
    
}
