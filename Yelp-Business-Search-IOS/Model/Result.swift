//
//  Result.swift
//
//  Created by Kiara Lei on 11/30/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

let HOST = "https://kiarahw8.wl.r.appspot.com"
let IP_TOKEN : String = "a3754846bd9a68"
let IP_HOST : String = "https://ipinfo.io/json"

struct Result : Identifiable,Decodable{
    var index : String
    var id : String
    var name : String
    var url : String
    var image_url : String
    var rating : Float
    var distance : Float
    var latitude : Double
    var longitude : Double
    
}

class ResultModel : ObservableObject {
    @Published var results : [Result] = []
    @Published var autoText : [String] = []
    @Published var hasResult : Bool = false
    @Published var noResult : Bool = false
    
//    @Published var showResultProgressView : Bool = false
//    @Published var result = Result(index: "", id: "", name: "", url: "", img: "", rating: "", distance: "")
    
    func getGeo(keyword : String, distance : String, category : String, location : String){
        let paramGeo = ["location" : location]
        AF.request(HOST + "/getGeo", parameters: paramGeo).responseJSON(){ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                if(data["status"].stringValue == "[ZERO_RESULTS]"){
                    //                  this.showNoResult();
                    return
                }
                debugPrint(json)
                let loc = data["results"][0]["geometry"]["location"]
                
                
                let paramYelp = [
                    "keyword" : keyword,
                    "distance" : distance,
                    "category" : category,
                    "lat" : loc["lat"].stringValue,
                    "lng" : loc["lng"].stringValue
                ]
                
                AF.request(HOST+"/getResult", parameters: paramYelp).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let data = JSON(value)
                        let businesses = data["data"]["businesses"]
                        
                        self.results = []
                        
                        for i in 0..<businesses.count {
                            let business = Result(index: String(i + 1), id: businesses[i]["id"].stringValue, name: businesses[i]["name"].stringValue, url: businesses[i]["url"].stringValue, image_url: businesses[i]["image_url"].stringValue, rating: businesses[i]["rating"].floatValue, distance: businesses[i]["distance"].floatValue, latitude: businesses[i]["coordinates"]["latitude"].doubleValue, longitude: businesses[i]["coordinates"]["longitude"].doubleValue)
                            
                            self.results.append(business)
                        }
                        
                        if(self.results.count == 0){
                            self.hasResult = false
                            self.noResult = true
                        }else{
                            self.hasResult = true
                            self.noResult = false
                        }
                        debugPrint(self.results)
                        
                        
                        
                        
                    case .failure(let error):
                        debugPrint("Error")
                        
                    }
                }
                
                
                
            case .failure(let error):
                debugPrint("Error")
            }
        }
    }
    
    func getIP(keyword : String, distance : String, category : String){
        let paramIP = ["token" : IP_TOKEN]
        
        AF.request(IP_HOST, parameters: paramIP).responseJSON(){ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                debugPrint(json)
                //"loc": "34.0766,-118.2646",
                let locStr = json["loc"].stringValue
                let locArray = locStr.split(separator: ",")
                
                
                let paramYelp = [
                    "keyword" : keyword,
                    "distance" : distance,
                    "category" : category,
                    "lat" : String(locArray[0]),
                    "lng" : String(locArray[1])
                ]
                
                AF.request(HOST+"/getResult", parameters: paramYelp).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let data = JSON(value)
                        let businesses = data["data"]["businesses"]
                        
                        self.results = []
                        
                        for i in 0..<businesses.count {
                            let business = Result(index: String(i + 1), id: businesses[i]["id"].stringValue, name: businesses[i]["name"].stringValue, url: businesses[i]["url"].stringValue, image_url: businesses[i]["image_url"].stringValue, rating: businesses[i]["rating"].floatValue, distance: businesses[i]["distance"].floatValue, latitude: businesses[i]["coordinates"]["latitude"].doubleValue, longitude: businesses[i]["coordinates"]["longitude"].doubleValue)
                            
                            self.results.append(business)
                        }
                        if(self.results.count == 0){
                            self.hasResult = false
                            self.noResult = true
                        }else{
                            self.hasResult = true
                            self.noResult = false
                        }
                        
                        debugPrint(self.results)
                        
                        
                        
                        
                    case .failure(let error):
                        debugPrint("Error")
                        
                    }
                }
                
                
                
            case .failure(let error):
                debugPrint("Error")
            }
            
            
        }
        
        
    }
    
    func clearResult(){
        self.results = []
        self.noResult = false
        self.hasResult = false
    }
    
    func getAutoCompleteText(text:String){
        self.autoText = []
        let paramAuto = ["text" : text]
        
        AF.request(HOST + "/getAutoComplete", parameters: paramAuto).responseJSON(){ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let data = json["data"]
                for i in 0..<data["categories"].count {
                    self.autoText.append(data["categories"][i]["title"].stringValue)
                }
                for i in 0..<data["terms"].count {
                    self.autoText.append(data["terms"][i]["text"].stringValue)
                }
                debugPrint(self.autoText)
                
            case .failure(let error):
                debugPrint("Error")
            }
            
        }
        
    }
}
