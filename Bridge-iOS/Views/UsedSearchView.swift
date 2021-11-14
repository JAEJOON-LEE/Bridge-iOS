//
//  UsedSearchView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/14.
//

import SwiftUI

struct UsedSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchString : String = ""
    
    var body: some View {
        VStack(spacing : 20) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 5)
                    TextField("", text: $searchString)
                }
                .foregroundColor(.gray)
                .frame(
                    width: UIScreen.main.bounds.width * 0.77,
                    height : UIScreen.main.bounds.height * 0.035
                )
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                }
                label : {
                    Text("Back")
                        .foregroundColor(.darkGray)
                }
            }
            
            HStack {
                Text("Categories")
                    .foregroundColor(.mainTheme)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            
            //["digital", "furniture", "food", "clothes", "beauty", "etc."]
            HStack {
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("digital")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("Digital")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("interior")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("Interior")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("life")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("Life")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            HStack {
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("fashion")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("Fashion")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("beauty")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("Beauty")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                NavigationLink {
                    
                } label: {
                    VStack(spacing : 5) {
                        Image("other_items")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(25)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.2,
                                height: UIScreen.main.bounds.width * 0.2)
                            .background(Color.systemDefaultGray)
                            .cornerRadius(20)
                        
                        Text("other Items")
                            .foregroundColor(.darkGray)
                            .fontWeight(.semibold)
                    }
                }
            }
            
            HStack {
                Text("[Camp name] Hot Deal")
                    .foregroundColor(.mainTheme)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.vertical, 20)

            Spacer()
        }.padding(20)
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}

struct UsedSearchView_Previews: PreviewProvider {
    static var previews: some View {
        UsedSearchView()
    }
}
