//
//  ReservationFormView.swift
//  Assignment9
//
//  Created by Kiara Lei on 12/5/22.
//

import SwiftUI


struct ReserveForm: View {
    let detail : Detail
    @Binding var showPopover : Bool
    @Binding var hasReserved : Bool
    @Binding var invalidateEmail : Bool
    
    
//    @State var fakeToast : Bool = true
    
//    @State var submitSuccess : Bool = false
    @State var email : String = ""
    @State private var date = Date()
    @State var hour : String = "10"
    @State var min : String = "00"
    
    let reserveModel = ReserveModel()
    
    
    // reference : https://www.abstractapi.com/guides/validate-email-in-swift
    func isValidEmailAddr(strToValidate: String) -> Bool {
      let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"

      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)

      return emailValidationPredicate.evaluate(with: strToValidate)
    }
    
    func clickReserve()  {
        if(!isValidEmailAddr(strToValidate: email)){
            invalidateEmail = true
            return
        }
        invalidateEmail = false
        reserveModel.reserve(id: detail.id,name:detail.name, email: email, date: date, hour: hour, min: min)
        hasReserved = true
        
        
        
        
        
//        submitSuccess = true
    }
    
    var body: some View {
        if(!hasReserved) {
            List{
                Section{
                    HStack{
                        Spacer()
                        Text("Reservation Form")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    
                }
                
                Section{
                    HStack {
                        Spacer()
                        Text(detail.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                }
                
                Section{
                        HStack{
                            Text("Email:")
                                .foregroundColor(Color.gray)
                            TextField("",text: $email)
                        }
                        
                        HStack{
                            Text("Date/Time:")
                                .foregroundColor(Color.gray)
                            
                            DatePicker(
                                    "",
                                    selection: $date,
                                    in:Date()...,
                                    displayedComponents: [.date]
                                )
                            if #available(iOS 15.0, *) {
                                HStack{
                                    Picker("Hour", selection: $hour) {
                                        ForEach((10...17), id: \.self) {
                                            Text("\($0)").tag("\($0)")
                                        }
                                    }.pickerStyle(.menu)
                                        .foregroundColor(Color.black)
                                        .tint(Color.black)
                                        .accentColor(Color.black)
                                    Text(":")
                                    Picker("Min", selection: $min) {
                                        Text("00").tag("00")
                                        Text("15").tag("15")
                                        Text("30").tag("30")
                                        Text("45").tag("45")
                                    }
                                    .pickerStyle(.menu)
                                    .foregroundColor(Color.black)
                                    .accentColor(Color.black)
                                    
                                    
                                }
                                .background(Color(uiColor: UIColor.secondarySystemFill))
                                .cornerRadius(10)
                            }
                        }
                        HStack{
                            Spacer()
                            if #available(iOS 15.0, *) {
                                Button {
                                    clickReserve()
                                } label: {
                                    Text("Submit")
                                        .frame(width: 80, height: 30)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.roundedRectangle)
                            } else {
                                // Fallback on earlier versions
                            }
                            Spacer()
                        }
                }
                
            }
        }
        else{
            Color.green.ignoresSafeArea()
                .overlay(
                    VStack {
                        Button {
                            self.showPopover = false
                        } label: {
                            VStack{
                                Spacer()
                                Text("Congratulations!")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.bottom)
                                Text("You have successfully made an reservation at \(detail.name)")
                                    .foregroundColor(Color.white)
                                Spacer()
                                if #available(iOS 15.0, *) {
                                    Button {
                                        self.showPopover = false
                                    } label: {
                                        Text("Done")
                                            .frame(width: 150)
                                    }
                                    .tint(Color.white)
                                    .foregroundColor(Color.green)
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.large)
                                    .buttonBorderShape(.capsule)

                                }
                            }

                        }

                    })

        }
    }
}

//
//struct ReservationFormView_Previews: PreviewProvider {
//    @ObservedObject var detailModel = DetailModel()
//    @State var showPopover = true
//    @State var hasReserved = false
//    static var previews: some View {
//        ReserveForm(detail : Detail(id: "", name: "maam", display_phone: "", location: "", price: "", photos: [], category: "", url: "", twUrl: "", fbUrl: "", isOpen: true))
//    }
//}
