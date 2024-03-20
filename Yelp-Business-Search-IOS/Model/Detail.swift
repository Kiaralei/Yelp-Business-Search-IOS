//
//  Detail.swift
//
//  Created by Kiara Lei on 11/30/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

//struct Photo : Identifiable, Decodable {
//    var id : UUID
//    var img_url : String
//}

struct Detail: Identifiable, Decodable {
    var id : String
    var name : String
    var display_phone : String
    var location : String
    var price : String
    var photos : [String]
//    var photos : [Photo]
    var category : String
    var url : String
    var twUrl : String
    var fbUrl : String
    var isOpen : Bool
}

class DetailModel : ObservableObject {
    @Published var detail = Detail(id: "", name: "", display_phone: "", location: "", price: "", photos: [], category: "", url: "", twUrl: "", fbUrl: "", isOpen: false)
    
    func getDetail( id : String){
        let paramDetail = ["id" : id]
        debugPrint(id)
        AF.request(HOST + "/getBusiness", parameters: paramDetail).responseJSON(){ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                debugPrint(data)
                
                // process category
                var cateStr = ""
                var cateArr : [String] = []
                for i in 0..<data["categories"].count {
                    cateArr.append(data["categories"][i]["title"].stringValue)
                }
                cateStr = cateArr.joined(separator: " | ")
                
                // process location
                var locationStr = ""
                var locationArr : [String] = []
                for i in 0..<data["location"]["display_address"].count {
                    locationArr.append(data["location"]["display_address"][i].stringValue)
                }
                locationStr = locationArr.joined(separator: ",")
                
                // process photos
//                var photoArr : [Photo] = []
//                for i in 0...data["photos"].count {
//                    let photoWrap = Photo(id: UUID(), img_url: data["photos"][i].stringValue)
//                    photoArr.append(photoWrap)
//                }
                var photoArr : [String] = []
                for i in 0..<data["photos"].count {
                    photoArr.append(data["photos"][i].stringValue)
                }
                
                // process twURL and fbURL
                let url = data["url"].stringValue
                var twUrl = "https://twitter.com/intent/tweet?text=" + data["name"].stringValue + "%20On%20Yelp&url=" + url
                var fbUrl = "https://www.facebook.com/sharer/sharer.php?u=" + url + "&quote="
                twUrl = self.removeSpace(str: twUrl)
                fbUrl = self.removeSpace(str: fbUrl)
                
                var isOpen = false
                // process isOpen
                if(data["hours"][0]["is_open_now"].exists()){
                    isOpen = data["hours"][0]["is_open_now"].boolValue
                }
                
                let detailWarp = Detail(id: data["id"].stringValue, name: data["name"].stringValue, display_phone: data["display_phone"].stringValue, location: locationStr, price: data["price"].stringValue, photos: photoArr, category: cateStr, url: url, twUrl: twUrl, fbUrl: fbUrl, isOpen: isOpen)
                
                self.detail = detailWarp
                
            case .failure(let error):
                debugPrint("Error")
            }
        }
    }
    
    func removeSpace(str : String) -> String{
        return str.replacingOccurrences(of: " ", with: "%20")
    }
    
}

