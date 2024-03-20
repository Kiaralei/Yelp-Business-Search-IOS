//
//  ContentView.swift
//  Assignment9
//
//  Created by Kiara Lei on 11/30/22.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State var keyword : String = ""
    @State var distance : String  = "10"
    @State var category = "all"
    @State var location : String = ""
    @State var autoDetect : Bool = false
    
    @State var showAutoComplete : Bool = false
    
    
    
    @StateObject var resultModel = ResultModel()
    @State var showProgress : Bool = false
    @State var showAutoTextProgress : Bool = false
    
    
    private func delayShow(flag : Int) {
        // Delay of 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if(flag == 1) {
                showProgress = false
            }else{
                showAutoTextProgress = false
            }
        }
    }

    func clickSubmit(){
        showProgress = true
        delayShow(flag: 1)
        
        if(autoDetect){
            resultModel.getIP(keyword: keyword, distance: distance, category: category)
        }else{
            resultModel.getGeo(keyword: keyword, distance: distance, category: category, location: location)
        }
    }
    
    func clickClear(){
        self.keyword = ""
        self.distance = "10"
        self.location = ""
        self.category = "all"
        self.autoDetect = false
        resultModel.clearResult()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Keyword:")
                            if #available(iOS 15.0, *) {
                                TextField("Required",text: $keyword)
                                    .onSubmit {
                                        resultModel.getAutoCompleteText(text: keyword)
                                        showAutoTextProgress = true
                                        showAutoComplete = true
                                    }
                                    .alwaysPopover(isPresented: $showAutoComplete) {
                                        VStack{
                                            if(resultModel.autoText.count == 0){
                                                ProgressView("loading...")
                                                    .frame(width: 800, height: 80)
                                            }else {
                                                ForEach(resultModel.autoText, id:\.self){ item in
                                                    Button {
                                                        self.keyword = item
                                                        showAutoComplete = false
                                                    } label: {
                                                        Text(item)
                                                            .padding(.leading)
                                                            .padding(.trailing)
                                                            .foregroundColor(Color.gray)
                                                    }.buttonStyle(.plain)

                                                }
                                            }
                                        }
                                    }
                            }
                                
                        }

                        HStack{
                            Text("Distance:")
                            TextField("Required",text: $distance)
                                .onChange(of: distance) { newValue in
                                    if(newValue == ""){
                                        distance = "0"
                                    }else if(newValue.prefix(1) == "0"){
                                        let str = newValue.suffix(1)
                                        distance = String(str)
                                    }
                                }
                        }
                        
                        HStack{
                            Text("Category:")
                            Picker("Category", selection: $category) {
                                Text("Default").tag("all")
                                Text("Arts & Entertainment").tag("arts")
                                Text("Health & Medical").tag("health")
                                Text("Hotels & Travel").tag("hotelstravel")
                                Text("Food").tag("food")
                                Text("Professional Services").tag("professional")
                            }.pickerStyle(.menu)
                        }
                        if(!autoDetect){
                            HStack{
                                Text("Location:")
                                TextField("Required",text: $location)
                            }
                        }
                        
                        HStack{
                            Toggle("Auto-detect my location:", isOn: $autoDetect)
                        }
                    
                        HStack {
                            Spacer()
                            if(keyword != "" && (location != "" || autoDetect == true)){
                                HStack(alignment: .center,  content:{
                                    Button(
                                        action: {
                                            clickSubmit()
                                        },
                                        label: {
                                            Text("Submit")
                                                
                                        })
                                        .frame(width: 70,height: 25)
                                        .foregroundColor(Color.white)
                                    
                                })
                                .padding(.leading,20)
                                .padding(.trailing,20)
                                .padding(.top,10)
                                .padding(.bottom,10)
                                .background(Color.red)
//                                .frame(width: 100)
                                .cornerRadius(10)
                            }else{
                                HStack(alignment: .center,  content:{
                                    Button("Submit", action: {})
                                        .disabled(true)
                                        .buttonStyle(BorderlessButtonStyle())
                                        .foregroundColor(Color.white)
                                        .frame(width: 70,height: 25)
                                    
                                })
                                .padding(.leading,20)
                                .padding(.trailing,20)
                                .padding(.top,10)
                                .padding(.bottom,10)
                                .background(Color.gray)
//                                .frame(width: 100,height: 40)
                                .cornerRadius(10)
                            }
                            
                            
                            
                            Spacer()
                            
                            HStack(alignment: .center ,content: {
                                if #available(iOS 15.0, *) {
                                    Button(
                                        action: {
                                            clickClear()
                                        },
                                        label: {
                                            Text("Clear")
                                              .frame(width: 80,height: 30)
                                        })
                                        .buttonStyle(.borderedProminent)
                                        .buttonBorderShape(.roundedRectangle)
                                        
                                } else {
                                    // Fallback on earlier versions
                                }
//                                .buttonStyle(BorderlessButtonStyle())
//                                .foregroundColor(Color.white)
                            })
//                                .padding(.leading,20)
//                                .padding(.trailing,20)
//                                .padding(.top,10)
//                                .padding(.bottom,10)
//                                .background(Color.blue)
//                                .frame(width: 100)
//                                .cornerRadius(10)
                            
                            
                            Spacer()
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    List {
                        Text("Results")
                            .font(.title)
                            .fontWeight(.bold)
                        if(!showProgress) {
                            
                            if(resultModel.hasResult && !resultModel.noResult) {
                                ForEach(resultModel.results) { result in
                                    NavigationLink(destination: {
                                        DetailView(result: result)
                                            .navigationBarTitleDisplayMode(.inline)                                            .navigationBarHidden(true)
                                    }, label: {
                                        HStack{
                                            Text(result.index)
                                                .fontWeight(.bold)
                                                .frame(width: 15)
                                            if(result.image_url != ""){
                                                KFImage(URL(string: result.image_url)!)
                                                    .resizable()
                                                    .frame(width: 40,height: 40)
                                                    .cornerRadius(5)
                                            }
                                            
                                            Text(result.name)
                                                .foregroundColor(Color.gray)
                                                .frame(width : 120)
                            
                                            
                                            Text(String(result.rating))
                                                .fontWeight(.bold)
                                                .frame(width : 50)
                                                
                                            Text(String(format: "%.0f", result.distance/1609.344))
                                                .fontWeight(.bold)
                                                .frame(width : 50)
                                        }
                                        
                                    })
                                }
                            }else if(!resultModel.hasResult && resultModel.noResult){
                                Text("No result available")
                                    .foregroundColor(Color.red)
                            }
                        }else{
                            HStack{
                                Spacer()
                                
                                VStack {
                                    ProgressView("Please wait...")
                                }
                                Spacer()
                            }
//
//
//
                        }
                    }
                    

                }
                
               
            }
                               
            .toolbar {
                ToolbarItem{
                    NavigationLink {
                        BookView()
                    } label: {
                        Image(systemName:"calendar.badge.clock")
                    }
                }
            }
            .navigationTitle("Business Search")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
