//
//  Movie.swift
//  MovieDatabase
//
//  Created by Justin Zaw on 01/12/2019.
//  Copyright © 2019 Justin Zaw. All rights reserved.
//

import Foundation
import SwiftyJSON


class Movie:NSObject, NSCoding{
    var title:String?
    var overview:String?
    var poster_path:String?
    var backdrop_path:String?
    var original_name:String?
    
    init(title:String,overview:String,poster_path:String,backdrop_path:String,original_name:String) {
        self.title = title
        self.overview = overview
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.original_name = original_name
    }
    
    class func initWith(json: JSON) -> Movie{
        let obj = Movie(title: json["title"].stringValue,
                        overview: json["overview"].stringValue,
                        poster_path: json["poster_path"].stringValue,
                        backdrop_path: json["backdrop_path"].stringValue,
                        original_name: json["original_name"].stringValue)
        
        return obj
    }

    class func createListOfMovie(json: JSON) -> NSArray{
        let list = NSMutableArray()
        let eventJsonArray = json.arrayValue
        for eventJson in eventJsonArray {
            let event = Movie.initWith(json: eventJson)
            list.add(event)
        }
        return list as NSArray
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let overview = aDecoder.decodeObject(forKey: "overview") as! String
        let poster_path = aDecoder.decodeObject(forKey: "poster_path") as! String
        let backdrop_path = aDecoder.decodeObject(forKey: "backdrop_path") as! String
        let original_name = aDecoder.decodeObject(forKey: "original_name") as! String
        self.init(title: title, overview: overview, poster_path: poster_path,backdrop_path: backdrop_path,original_name:original_name)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(overview, forKey: "overview")
        aCoder.encode(poster_path, forKey: "poster_path")
        aCoder.encode(backdrop_path, forKey: "backdrop_path")
        aCoder.encode(original_name, forKey: "original_name")
    }
}


