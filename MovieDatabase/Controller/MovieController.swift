//
//  MovieController.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 30/11/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"
private let loadingIdentifier = "LoadingCells"

class MovieController: UICollectionViewController {
    
    var searchBar: UISearchBar!
    var movieList:[Movie] = []
    var isDownloadCompleted:Bool = false
    let defaults = UserDefaults.standard
    
    var inSearchMode = false
    var filteredMovie = [Movie]()
    
    var currentPage = 1
    var numberOfPages = 0
    var isLoading = false
    private var shouldShowLoadingCell = false
    
    let movieListUrl = "https://api.themoviedb.org/3/movie/popular?api_key=db85bc6bf1d96e2f47ac91af80e1d717&language=en-US&page="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponent()
        //prepareData() //this func is close when is pagination func is work
        
        if Reachability.isConnectedToNetwork(){
            loadMovie(currentPage)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    
    func loadMovie(_ currentPage:Int){
        
        WSAPIClient.shared.getMovieWithPage(page: currentPage) { (response, statuscode) in
            if statuscode == 200 {
                
                let json = response["results"]
                self.numberOfPages = response["total_pages"].intValue
                self.movieList = Movie.createListOfMovie(json: json) as! [Movie]
                 self.shouldShowLoadingCell = self.currentPage < self.numberOfPages
                self.collectionView.reloadData()
            }
        }
    }
    
            
    
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.movieList.count
    }

    func fetchNextPage(){
        currentPage += 1
        WSAPIClient.shared.getMovieWithPage(page: currentPage) { (response, statuscode) in
            if statuscode == 200 {
                var tempList:[Movie] = []
                let json = response["results"]
                tempList = Movie.createListOfMovie(json: json) as! [Movie]
                self.movieList.append(contentsOf: tempList)
                self.collectionView.reloadData()
            }
        }
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
        collectionView.register(LoadingCells.self, forCellWithReuseIdentifier: loadingIdentifier)
        

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
        //return inSearchMode ? filteredMovie.count : movieList.count  //self.movieList.count
        
        if inSearchMode {
            return filteredMovie.count
        }else {
             let count = movieList.count
            return shouldShowLoadingCell ? count + 1 : count
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                if isLoadingIndexPath(indexPath) {
                    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: loadingIdentifier, for: indexPath) as! LoadingCells
                    return cell
                    
                }else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
                    if inSearchMode {
                        
                        cell.setData(obj: self.filteredMovie[indexPath.row])
                        cell.backgroundColor = .green
                              return cell
                        
                    }else{
                        cell.setData(obj: self.movieList[indexPath.row])
                        cell.backgroundColor = .green
                              return cell
                    }
                }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 10, bottom: 8, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 30) / 2
        if isLoadingIndexPath(indexPath){
            return CGSize(width: width, height: 80)
        }
            
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

extension MovieController{
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 0.0 {
           
                if currentPage < numberOfPages{
                    fetchNextPage()
                }
            
        }
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

