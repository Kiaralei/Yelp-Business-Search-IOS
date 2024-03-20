//
//  BusinessView.swift
//  Assignment9
//
//  Created by Kiara Lei on 12/3/22.
//

import SwiftUI
import Kingfisher

struct BusinessView: View {
    let result : Result
    
    
    @State var showPopover = false
    @State var hasReserved = false
    @State var invalidateEmail = false
    @State var cancelReserve = false
    
    @ObservedObject var detailModel = DetailModel()
    @ObservedObject var reserveModel = ReserveModel()
    
    init(result : Result){
        self.result = result
        detailModel.getDetail(id: self.result.id)
        
        self.initReserved()
    }
    
    mutating func initReserved(){
        hasReserved = reserveModel.isReserved(id: detailModel.detail.id)
    }

    var body: some View {
        VStack {
            Text(detailModel.detail.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            VStack{
                HStack(alignment: .top, content: {
    
                    VStack(alignment: .leading,  content: {
                        
                        Text("Address")
                            .font(.headline)
                        Text(detailModel.detail.location )
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                            .foregroundColor(Color.gray)
//                        Spacer()
                    })
                    Spacer()
                    
                    VStack(alignment: .trailing,  content:{
                        Text("Category")
                            .font(.headline)
                        Text(detailModel.detail.category)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                            .foregroundColor(Color.gray)
//                        Spacer()
                    })
                    
                })
//                    .background(Color.red)
                
                HStack(alignment: .top, content: {
                    VStack(alignment: .leading) {
                        Text("Phone")
                            .font(.headline)
                        Text(detailModel.detail.display_phone)
                            .padding(.bottom)
                            .foregroundColor(Color.gray)
                        
                        Text("Status")
                            .font(.headline)
                        if(detailModel.detail.isOpen){
                            Text("Open Now")
                                .foregroundColor(Color.green)
                                .padding(.bottom)
                        }else {
                            Text("Closed")
                                .foregroundColor(Color.red)
                                .padding(.bottom)
                        }
//                        Spacer()
                        
                        
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        
                        Text("Price Range")
                            .font(.headline)
                        Text(detailModel.detail.price)
                            .padding(.bottom)
                            .foregroundColor(Color.gray)
                        
                        Text("Visit Yelp for more")
                            .font(.headline)
                        if(detailModel.detail.url != ""){
                            Link(destination: URL(string: detailModel.detail.url)!) {
                                Text("Business Link")
                                    .padding(.bottom)
                            }
                        }
                        
                    }
                })
//                .padding()
                .frame(width: .infinity)
//                .background(Color.blue)
            }.padding(.leading)
                .padding(.trailing)
            
            
            
            
            if(hasReserved || reserveModel.isReserved(id: detailModel.detail.id)){
                HStack{
                    Button {
                        reserveModel.deleteReserve(id: detailModel.detail.id)
                        cancelReserve = true
                        hasReserved = false
                    } label: {
                        Text("Cancel Reservation")
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 15)
                .padding(.bottom, 15)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
            }else{
                //
                HStack{
                    Button {
                        showPopover = true
                    } label: {
                        Text("Reserve Now")
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 15)
                .padding(.bottom, 15)
                .background(Color.red)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
            
            
            
            HStack{
                Text("Share on:")
                if(detailModel.detail.fbUrl != ""){
                    Link(destination: URL(string: detailModel.detail.fbUrl)!) {
                        Image("facebook")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
                if(detailModel.detail.twUrl != ""){
                    Link(destination: URL(string: detailModel.detail.twUrl)!) {
                        Image("twitter")
                            .resizable()
                            .frame(width: 40, height: 40)
                   }
                }
            }
            if(detailModel.detail.photos.count > 0){
                TabView{
                    ForEach(0..<detailModel.detail.photos.count, id:\.self){ i in
                        if(detailModel.detail.photos[i] != ""){
                            KFImage(URL(string: detailModel.detail.photos[i])!)
                                .resizable()
                                .frame(width: .infinity,height: .infinity)
                                .padding()
                        }
                    }
                }.tabViewStyle(.page)
//                    .id(detailModel.detail.photos.count)
                
            }
                
        }
        .toast(isPresented: $cancelReserve) {
            HStack {
                Text("Your reservation is cancelled.")
            }
        }
        
        .popover(isPresented: $showPopover) {
            ReserveForm(detail : detailModel.detail, showPopover : $showPopover, hasReserved: $hasReserved, invalidateEmail: $invalidateEmail)
            
            
                .toast(isPresented: $invalidateEmail) {
//                    if #available(iOS 15.0, *) {
//                        HStack {
//                            Text("Please enter a valid email.")
//                        }
//                        .background(Color(uiColor: UIColor.systemFill))
//                    }
                    Text("Please enter a valid email.")
//                        .background(Color.gray)
                }
            
                
        }
        
        
        
    }
      
}

struct BusinessView_Previews: PreviewProvider {
//    let result = Result(index: "String", id: "YBmk31pBPukmnRyioe5uBA", name: "", url: "", image_url: "", rating: 0.0, distance: 0.0)
    static var previews: some View {
        BusinessView(result: Result(index: "", id: "YBmk31pBPukmnRyioe5uBA", name: "Izakaya Osen - Los Angeles", url: "", image_url: "", rating: 0.0, distance: 0.0, latitude: 34, longitude: -118))
    }
}



