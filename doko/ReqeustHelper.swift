//
//  ReqeustHelper.swift
//  doko
//
//  Created by Eric on 2018/9/8.
//  Copyright © 2018 Emily. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct Post {
    public var id: String
    public var location: [Double]
    public var distance: Double
    public var spotId: String
}

public struct PostContent {
    public var text: String
    public var images: [String]
    public var source: String
    public var url: String
}

public struct Restaurant {
    public var name: String
    public var id: String
    public var description: String
    public var tags: [String]
    public var rank: Int
}

public struct Spot {
    public var name: String
    public var id: String
    public var location: [Double]
    public var postContent: PostContent
    public var restaurant: Restaurant
}

public func getPostsByLocation(lat:Float, lon:Float, _ callback: @escaping (_ post: [Post]) -> ()) {
    let params = ["lat":lat, "lon":lon, "range": 1000]
    Alamofire.request("https://webhooks.mongodb-stitch.com/api/client/v2.0/app/doko-oazxq/service/getRecents/incoming_webhook/recents?", parameters:params).responseJSON { response in
        
        var posts: [Post] = []
        
        JSON(response.result.value!).array!.forEach({ json in
            let post = Post(id: json["id"].string!, location: [Double(json["location"]["lon"]["$numberDouble"].string!)!, Double(json["location"]["lat"]["$numberDouble"].string!)!], distance: Double(json["distance"]["$numberDouble"].string!)!, spotId: json["spotId"].string!)
            posts.append(post)
        })
        
        callback(posts)
    }
}
    
   public func getSpotById(id:String,  _ callback: @escaping (_ spot: Spot) -> ()) {
        let params = ["id": id]
        Alamofire.request("https://webhooks.mongodb-stitch.com/api/client/v2.0/app/doko-oazxq/service/getRecents/incoming_webhook/post?i", parameters:params).responseJSON { response in
            let json: JSON = JSON(response.result.value!)
            let name :String! = json["name"].string!
            let id :String! = json["id"].string!
            let location :[Double]! = [Double(json["location"]["lon"]["$numberDouble"].string!)!, Double(json["location"]["lat"]["$numberDouble"].string!)!]
            let _postContent: JSON = json["postContent"]
            
            var images: [String] = []
            _postContent["images"].array!.forEach({ image in
                images.append(image.string!)
            })
            
            let postContent :PostContent = PostContent(text:_postContent["text"].string!, images: images, source: _postContent["source"].string!, url: _postContent["url"].string!)
            let _restaurant = json["restaurant"]
            
            var tags: [String] = []
            _restaurant["tags"].array!.forEach({ tag in
                    tags.append(tag.string!)
            })
            
            let restName :String! = _restaurant["name"].string!
            let restId :String! = _restaurant["id"].string!
            let restDesc :String! = _restaurant["description"].string!
            let restaurant :Restaurant = Restaurant(name: restName!, id: restId!, description: restDesc!, tags: tags, rank: Int(_restaurant["rank"]["$numberInt"].string!)!)
            
            let spot = Spot(
                name: json["name"].string!,
                id: json["id"].string!,
                location: [Double(json["location"]["lon"]["$numberDouble"].string!)!, Double(json["location"]["lat"]["$numberDouble"].string!)!],
                postContent: postContent,
                restaurant: restaurant)
            
            callback(spot)
        }
    }

