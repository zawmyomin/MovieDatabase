//
//  MovieController.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 30/11/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"

class MovieController: UICollectionViewController {
    
    var searchBar: UISearchBar!
    var movieList:[Movie] = []
    var isDownloadCompleted:Bool = false
    let defaults = UserDefaults.standard
    
    var inSearchMode = false
    var filteredMovie = [Movie]()
    
    let movieListUrl = "https://api.themoviedb.org/3/movie/popular?api_key=db85bc6bf1d96e2f47ac91af80e1d717&language=en-US&page=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponent()
        prepareData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
        
    func getSearchData(searchKey: String){
           
        WSAPIClient.shared.getSmartSearchData(keyword: searchKey) { (response, status) in
            if status == 200 {
                let json = response["results"]
                self.filteredMovie = []
                self.filteredMovie = Movie.createListOfMovie(json: json) as! [Movie]
                let i =  IndexPath(row: -1, section: 0)
                self.collectionView.scrollToItem(at: i, at: .top, animated: true)
                
                self.collectionView.reloadData()
                
            }else {
                
              print("No search data")
            }
            
            
        }
    }
    
    func prepareData(){
        let status = UserDefaults.standard.string(forKey: "isMovieDownloaded") ?? ""
               self.isDownloadCompleted = status == "true" ? true : false
               
               if Reachability.isConnectedToNetwork(){
                   if self.movieList.count == 0 {
                       self.getDataList(self.movieListUrl)
                   }
                   
               }else{
                   showAlert()
                   if self.isDownloadCompleted{
                       self.movieList = []
                       self.movieList = WSAPIClient.shared.retrieveDataFromUserDefault(key: "SavedMovie")
                       self.collectionView.reloadData()
                   }
                   
               }
    }
    
    func getDataList(_ url:String){
        WSAPIClient.shared.getDatalist(url: url) { (response, status) in
            if status == 200 {
                let json = response["results"]
                self.movieList = Movie.createListOfMovie(json: json) as! [Movie]
                self.collectionView.reloadData()
                self.defaults.set("true", forKey: "isMovieDownloaded")
                WSAPIClient.shared.saveDataToUserDefault(data: self.movieList, key: "SavedMovie")
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "No internet connection!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true)
    }
    
    func configureViewComponent(){
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .mainGreen()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "MOVIES"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.keyboardDismissMode = .onDrag
        
////        view.addSubview(lblNoData)
//        lblNoData.isHidden = true
//        lblNoData.translatesAutoresizingMaskIntoConstraints = false
//        lblNoData.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        lblNoData.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }
    
     let lblNoData: UILabel = {
           let label = UILabel()
           label.text = "Sorry We do not have result for"
           label.font = UIFont.systemFont(ofSize: 16,weight: .medium)
           label.textColor = .mainGreen()
           label.numberOfLines = 0
           return label
       }()
    
    @objc func showSearch(){
        configureSearchBar()
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.tintColor = .white
        searchBar.placeholder = "Search Movies"
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
    }
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    
    @objc func showSearchBar() {
        configureSearchBar()
    }

}


extension MovieController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredMovie.count : movieList.count  //self.movieList.count
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
        if inSearchMode {
            
            cell.setData(obj: self.filteredMovie[indexPath.row])
            
        }else{
            cell.setData(obj: self.movieList[indexPath.row])
        }
        
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 10, bottom: 8, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 280)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MovieDetailController()
        if inSearchMode {
            controller.obj = self.filteredMovie[indexPath.row]
            
        }else {
            controller.obj = self.movieList[indexPath.row]
        
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
   
    

    
    
}

extension MovieController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureSearchBarButton()
        inSearchMode = false
        view.endEditing(true)
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            if searchText == "" || searchBar.text == nil {
                       inSearchMode = false
                       collectionView.reloadData()
                       view.endEditing(true)
                   } else {

                    if searchText.count > 2 {
                        if Reachability.isConnectedToNetwork(){
                            inSearchMode = true
                            getSearchData(searchKey: searchText)
                            
                            
                        }else {
                            showAlert()
                            collectionView.reloadData()
                            view.endEditing(true)
                        }
                   
                }

            }

    }
    
    

}

