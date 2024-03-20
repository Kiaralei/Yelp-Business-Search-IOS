//
//  Review.swift
//
//  Created by Kiara Lei on 12/2/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Review: Decodable, Identifiable {
    var id : String
    var text : String
    var userName : String
    var rating : Float
    var time_created : String
}

class ReviewModel : ObservableObject {
    @Published var reviews : [Review] = []
    
    func getReview(id: String){
        let paramReview = ["id" : id]
        
        AF.request(HOST + "/getReview", parameters: paramReview).responseJSON(){ response in
            switch response.result {
            case .success(let value):
                self.reviews = []
                let json = JSON(value)
                let data = json["data"]["reviews"]
                var reviewArr : [Review] = []
                
                for i in 0..<data.count {
                    var time = data[i]["time_created"].stringValue
//                    let start = createTime.index(createTime.startIndex, offsetBy: 0)
//                    let end = createTime.index(createTime.endIndex, offsetBy: -9)
//                    let range = start..<end
                     
                    let createTime = time.dropLast(9)
                    debugPrint(time)
//                    createTime = createTime.substring(to:createTime.index(createTime.startIndex, offsetBy: 9))
                    
                    let reviewWrap = Review(id: data[i]["id"].stringValue, text: data[i]["text"].stringValue, userName: data[i]["user"]["name"].stringValue, rating: data[i]["rating"].floatValue, time_created: String(createTime))
                    reviewArr.append(reviewWrap)
                }
                
                self.reviews = reviewArr
//                self.reviews.removeLast()
                debugPrint(self.reviews)
            case .failure(let error):
                debugPrint(error)
            }
            
        }
        
    }
}


