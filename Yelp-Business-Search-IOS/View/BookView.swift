//
//  BookView.swift
//  Assignment9
//
//  Created by Kiara Lei on 11/30/22.
//

import SwiftUI

struct BookView: View {
    @StateObject var reserveModel = ReserveModel()
    let date = Date()
    let dateFormatter = DateFormatter()
//    @StateObject var reserveListState =
    
    
    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        reserveModel.getReserveList()
    }
    
    var body: some View {
        VStack{
            if(reserveModel.reserveList.count != 0) {
                
                List {
                    ForEach(reserveModel.reserveList){ item in
                        if #available(iOS 15.0, *) {
                            HStack{
                                Text(item.name)
                                    .frame(width: 80)
                                    .font(.system(size: 12))

                                Text(dateFormatter.string(from: item.date))
                                    .font(.system(size: 12))
                                    .frame(width: 80)
                                HStack{
                                    Text(item.hour + ":" + item.min)
                                        .font(.system(size: 12))
                                        .frame(width: 40)
                                }

                                Text(item.email)
                                    .frame(width: 100)
                                    .font(.system(size: 12))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    reserveModel.deleteReserve(id: item.id)
                                } label: {
                                    Text("delete")
                                }.background(Color.red)
                            }
                            
                            
                        }
                    }
                }
        
            }
            else{
                Text("No bookings found")
                    .foregroundColor(Color.red)
            }
        }
        
        .navigationTitle("Your Reservations")
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
    }
}
