//
//  TvShowController.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 30/11/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import UIKit

private let tshowloadingIdentifier = "LoadingCells"
class TvShowController: UITableViewController{
    
    let tvListUrl = "https://api.themoviedb.org/3/tv/popular?api_key=db85bc6bf1d96e2f47ac91af80e1d717&language=en-US&page=1"
    
    var dataList:[Movie] = []
    var isDownloadCompleted:Bool = false
    let defaults = UserDefaults.standard
    
    var searchBar : UISearchBar!
    var inSearchMode = false
    var filteredMovie = [Movie]()
    
    var currentPage = 1
    var numberOfPages = 0
    var isLoading = false
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponent()
//        prepareData()
        
        if Reachability.isConnectedToNetwork(){
        self.loadTvShow(self.currentPage)
           }
    }
    
      override func viewWillAppear(_ animated: Bool) {
          tabBarController?.tabBar.isHidden = false
          navigationController?.navigationBar.isHidden = false
      }
    
    func loadTvShow(_ currentPage:Int){
        
        WSAPIClient.shared.getTvShowWithPage(page: currentPage) { (response, statuscode) in
            if statuscode == 200 {
                
                let json = response["results"]
                self.numberOfPages = response["total_pages"].intValue
                self.dataList = Movie.createListOfMovie(json: json) as! [Movie]
                self.shouldShowLoadingCell = self.currentPage < self.numberOfPages
                self.tableView.reloadData()
            }
        }
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.dataList.count
    }
    
    
    func fetchNextPage(){
        currentPage += 1
        WSAPIClient.shared.getTvShowWithPage(page: currentPage) { (response, statuscode) in
            if statuscode == 200 {
                var tempList:[Movie] = []
                let json = response["results"]
                
                tempList = Movie.createListOfMovie(json: json) as! [Movie]
                self.dataList.append(contentsOf: tempList)
                self.tableView.reloadData()
            }
        }
    }

    
       
    func getTvSearchData(searchKey: String){
           
        WSAPIClient.shared.getTvSearchData(keyword: searchKey) { (response, status) in
            if status == 200 {
                let json = response["results"]
                self.filteredMovie = []
                self.filteredMovie = Movie.createListOfMovie(json: json) as! [Movie]
                let i =  IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: i, at: .top, animated: true)
                
                self.tableView.reloadData()
                
            }else {
              print("No search data")
            }
            
            
        }
    }
    
    func prepareData(){
        let status = UserDefaults.standard.string(forKey: "isTVDownloaded") ?? ""
        self.isDownloadCompleted = status == "true" ? true : false
        
        if Reachability.isConnectedToNetwork(){
            if self.dataList.count == 0 {
                self.getDataList(self.tvListUrl)
            }
            
        }else{
            showAlert()
            if self.isDownloadCompleted{
                self.dataList = []
                self.dataList = WSAPIClient.shared.retrieveDataFromUserDefault(key: "SavedTV")
                self.tableView.reloadData()
            }
            
        }
    }
    
    func getDataList(_ url:String){
        WSAPIClient.shared.getDatalist(url: url) { (response, status) in
            if status == 200 {
                let json = response["results"]
                self.dataList = Movie.createListOfMovie(json: json) as! [Movie]
                self.tableView.reloadData()
                self.defaults.set("true", forKey: "isTVDownloaded")
                WSAPIClient.shared.saveDataToUserDefault(data: self.dataList, key: "SavedTV")
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
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .mainGreen()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "TV SHOW"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        let cellNib = UINib(nibName: "TVCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "TVCell")
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        
        
        
    }
    
    let lblNoData: UILabel = {
        let label = UILabel()
        label.text = "Sorry We do not have result for"
        label.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        label.textColor = .mainGreen()
        label.numberOfLines = 0
        return label
    }()
    
    @objc func showSearchBar(){
        configureSearchBar()
    }
    
    func configureSearchBar() {
           searchBar = UISearchBar()
           searchBar.delegate = self
           searchBar.sizeToFit()
           searchBar.showsCancelButton = true
           searchBar.becomeFirstResponder()
           searchBar.tintColor = .white
           searchBar.placeholder = "Search TV Show"
           navigationItem.rightBarButtonItem = nil
           navigationItem.titleView = searchBar
       }
    
    func configureSearchBarButton() {
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
           navigationItem.rightBarButtonItem?.tintColor = .white
       }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //inSearchMode ? filteredMovie.count : dataList.count
        if inSearchMode {
            return filteredMovie.count
        }else {
            let count = dataList.count
            return shouldShowLoadingCell ? count + 1 : count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingIndexPath(indexPath) {
            return TvShowLoadingCell(style: .default, reuseIdentifier: tshowloadingIdentifier)
         }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell" , for: indexPath) as! TVCell
            cell.backgroundColor = .white
            
            if inSearchMode {
                
                cell.setData(obj: self.filteredMovie[indexPath.row])
                
            }else{
                cell.setData(obj: self.dataList[indexPath.row])
            }

            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isLoadingIndexPath(indexPath){
            return 40
        }else{
            return 230
        }
//        return 230
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailController()
        
        if inSearchMode {
                   vc.obj = self.filteredMovie[indexPath.row]
                   
               }else {
                   vc.obj = self.dataList[indexPath.row]
               
               }
        
        vc.isComeFromTV = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension TvShowController{
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
          
        
          let currentOffset = scrollView.contentOffset.y
          let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
          
          if maximumOffset - currentOffset <= 0.0 {
             
                  if currentPage < numberOfPages{
                      fetchNextPage()
                  }
          }
      }
}


extension TvShowController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        configureSearchBarButton()
        inSearchMode = false
        view.endEditing(true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            if searchText == "" || searchBar.text == nil {
                       inSearchMode = false
                       tableView.reloadData()
                       view.endEditing(true)
                   } else {

                    if searchText.count > 2 {
                        if Reachability.isConnectedToNetwork(){
                            inSearchMode = true
                            getTvSearchData(searchKey: searchText)
                        }else {
                            showAlert()
                            tableView.reloadData()
                            view.endEditing(true)
                        }

                }

            }
    }
    
}

