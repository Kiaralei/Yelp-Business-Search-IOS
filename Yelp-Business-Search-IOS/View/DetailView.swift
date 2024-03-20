//
//  DetailView.swift
//  Assignment9
//
//  Created by Kiara Lei on 11/30/22.
//

import SwiftUI
import MapKit
import UIKit

struct DetailView: View {
    let result : Result
    @State var cancelReserve = true
    @State var showSheet : Bool = true
    
    var body: some View {
        TabView {
            BusinessView(result: result)
                .tabItem {
                        Label("Business Detail", systemImage: "text.bubble.fill")
                }
            
            MapDetailView(result : result)
                .tabItem {
                    Label("Map Location", systemImage: "location.fill")
                }
            
            ReviewView(result: result)
                .tabItem {
                    Label("Reviews", systemImage: "message.fill")
                }
            
              
            
        }
        
        
    }
}


struct MapDetailView: View {
    let result : Result
    let mapModel = MapModel()
    
    @State private var region : MKCoordinateRegion
        
    init(result : Result){
        self.result = result
        debugPrint(result)
        mapModel.getMap(result: result)
        self.region = mapModel.region
    }
    
    
    

    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: [mapModel.place]) { place in
            MapMarker(coordinate: place.location, tint: .red)
        }
    }
}

struct ReviewView: View {
    let result : Result
    @ObservedObject var reviewModel = ReviewModel()
    @State var showProgresView = false
    
    init(result : Result){
        self.result = result
        self.showProgresView = true
        delayShow()
        reviewModel.getReview(id: self.result.id)
    }
    
    private func delayShow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showProgresView = false
        }
    }
    
    var body: some View {
        if(showProgresView){
            ProgressView("Please wait...")
        }else{
            List{
                ForEach(reviewModel.reviews){ review in
                    VStack{
                        HStack{
                            VStack(alignment: .leading){
                                Text(review.userName)
                                    .fontWeight(.bold)
                            }.padding(.leading, 15)
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(format: "%.0f",review.rating) + "/5")
                                    .fontWeight(.bold)
                            }.padding(.trailing, 15)
                        }
                            
                        Text(review.text)
                                .padding(.leading)
                                .padding(.trailing)
                                .foregroundColor(Color.gray)
                        Text(review.time_created)
                    }
                    .padding(.bottom)
                }
            }
        }
            
    }
}



struct DetailView_Previews: PreviewProvider {
//    let result = Result(index: "String", id: "YBmk31pBPukmnRyioe5uBA", name: "", url: "", image_url: "", rating: 0.0, distance: 0.0)
    static var previews: some View {
        DetailView(result: Result(index: "", id: "YBmk31pBPukmnRyioe5uBA", name: "", url: "", image_url: "", rating: 0.0, distance: 0.0, latitude: 34, longitude: -118))
    }
}

