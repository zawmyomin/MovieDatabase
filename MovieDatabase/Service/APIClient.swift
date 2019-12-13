//
//  APIClient.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage


class WSAPIClient {
    
static let shared = WSAPIClient()
    

func getSmartSearchData(keyword: String,completion: @escaping (JSON, Int) -> Void){
    
//    let url = " http://api.themoviedb.org/3/search/person?api_key=db85bc6bf1d96e2f47ac91af80e1d717&query=\(keyword)"
   // let url = " http:/f/api.themoviedb.org/3/search/person?api_key=db85bc6bf1d96e2f47ac91af80e1d717&query=morgan+freeman"
    //let escapedURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    
    let url = "https://api.themoviedb.org/3/search/movie?api_key=db85bc6bf1d96e2f47ac91af80e1d717&language=en-US&query=\(keyword)&page=1&include_adult=false"
    let escapedURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    Alamofire.request(escapedURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData{ (response) in
               let statusCode = response.response?.statusCode
               if statusCode == 200 {
                   let json = JSON(response.result.value!)
                   completion(json, statusCode!)
               }else{
                   completion(JSON.null, statusCode!)
               }
           }
    
       }
    
    func getTvSearchData(keyword: String, completion: @escaping (JSON, Int) -> Void){
        
        
        let url = "https://api.themoviedb.org/3/search/tv?api_key=db85bc6bf1d96e2f47ac91af80e1d717&language=en-US&query=\(keyword)&page=1&include_adult=false"
        let escapedURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        Alamofire.request(escapedURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData{ (response) in
                   let statusCode = response.response?.statusCode
                   if statusCode == 200 {
                       let json = JSON(response.result.value!)
                       completion(json, statusCode!)
                   }else{
                       completion(JSON.null, statusCode!)
                   }
               }
    }
    
    
    
    
    func getDatalist(url: String,completion: @escaping (JSON, Int) -> Void){
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData{ (response) in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let json = JSON(response.result.value!)
                completion(json, statusCode!)
            }else{
                completion(JSON.null, statusCode!)
            }
        }
    }
    
    func getImageWithUrl(url: URL, completion: @escaping (_ image: UIImage?, _ status:Int ) -> Void){
    
        Alamofire.request(url, method: .get)
               .validate()
               .responseData(completionHandler: { (response) in
                if let image = UIImage(data: response.data!){
                    completion(image, response.response!.statusCode)
                }})
    }

    func saveDataToUserDefault(data:[Movie],key:String){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
    
    func retrieveDataFromUserDefault(key:String)->[Movie]{
        let defaults = UserDefaults.standard
        let decoded  = defaults.data(forKey: key)
       
        if decoded?.count == 0{
            return []
        }else{
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Movie]
            return decodedData
        }
        
       
    }
}

