//
//  Reservation.swift
//
//  Created by Kiara Lei on 12/4/22.
//

import SwiftUI

struct ReserveInfo : Identifiable, Codable {
    var id : String
    var name : String
    var email : String
    var date : Date
    var hour : String
    var min : String
}

class ReserveModel : ObservableObject {
    @Published var reserveList : [ReserveInfo] = []
    
    init(){
//        self.reserveList = self.getReserveList()
        do {
            if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                if let reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                    self.reserveList = reservationArray
                }
            }
            
        }catch {
            
        }
    }
    
    func reserve(id:String,name:String,email:String,date:Date,hour:String,min:String) {
        let reserveInfo = ReserveInfo(id: id,name: name, email: email, date: date, hour: hour, min: min)
        do {
            if(UserDefaults.standard.object(forKey: "MyBooking") != nil){
                if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                    if var reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                        print(reservationArray)
                        
                        
                        reservationArray.append(reserveInfo)
                        self.reserveList = reservationArray
                        print(reservationArray)
                        if let arrayEncode = try? JSONEncoder().encode(reservationArray) {
                            UserDefaults.standard.set(arrayEncode, forKey: "MyBooking")
                        }
                        
                    }
                }
            } else {
                var newArray : [ReserveInfo] = []
                newArray.append(reserveInfo)
                if let newArrayEncode = try? JSONEncoder().encode(newArray) {
                    UserDefaults.standard.set(newArrayEncode, forKey: "MyBooking")
                    debugPrint(UserDefaults.standard.bool(forKey: "MyBooking"))
                    
                    self.reserveList = newArray
                    
                    // JUST FOR TEST
                    if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                        if var reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                            print(reservationArray)
                        }
                    }
                    
                }
            }
        }catch{
            
        }
        
        
    }
    
    func deleteReserve(id:String){
        do {
            if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                if var reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                    print(reservationArray)
                    let newArray = reservationArray.filter({ (dictionary) -> Bool in
                        if let value = dictionary.id as? String{
                            return value != id
                        }
                        return false
                    })
                    print(newArray)
                    
                    if let newArrayEncode = try? JSONEncoder().encode(newArray) {
                        UserDefaults.standard.set(newArrayEncode, forKey: "MyBooking")
                        self.reserveList = newArray
                    }
                    
                }
            }
        } catch {
            
        }
    }
    
    func isReserved(id:String) -> Bool {
        do {
            if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                if var reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                    print(reservationArray)
                    for i in 0..<reservationArray.count {
                        if(reservationArray[i].id == id) {
                            return true
                        }
                    }
                }
            }
            return false
            
        }catch {
            
        }
        
    }
    
    func getReserveList() {
        do {
            if let reservationArrayEncode = UserDefaults.standard.object(forKey: "MyBooking") as? Data {
                if let reservationArray = try? JSONDecoder().decode([ReserveInfo].self, from: reservationArrayEncode) {
                    self.reserveList = reservationArray
                    debugPrint(self.reserveList)
//                    return reservationArray
                    
//                    debugPrint(reserveList)
                }
            }
            
        }catch {
            
        }
    }
}
