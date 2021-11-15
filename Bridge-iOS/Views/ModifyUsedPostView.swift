//
//  ModifyUsedPostView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/10/14.
//

import SwiftUI
import URLImage

struct ModifyUsedPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : ModifyUsedPostViewModel
    @Binding var isModifyDone : Bool
    
    init(viewModel : ModifyUsedPostViewModel, isModifyDone : Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isModifyDone = Binding(projectedValue: isModifyDone)
    }

    var body: some View {
        VStack {
            Spacer().frame(height: UIScreen.main.bounds.height * 0.02)
            TabView {
                ForEach(viewModel.postImages, id : \.self) {
                    URLImage(URL(string : $0.image) ??
                             URL(string: "https://static.thenounproject.com/png/741653-200.png")!
                         ) { image in
                             image
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                         }
                }
            }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)

            HStack {
                Spacer()
                Text("\(viewModel.postImages.count) / 7")
                    .foregroundColor(.gray)
                Image(systemName: "camera")
                    .foregroundColor(.mainTheme)
            }.padding(.horizontal, 20)
            
            VStack {
                VStack(spacing : 0) {
                    TextField(" Title", text: $viewModel.title)
                        .font(.system(size : 18, weight : .semibold))
                        .autocapitalization(.none)
                        .frame(height : UIScreen.main.bounds.height * 0.05)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.systemDefaultGray)
                        .frame(width : UIScreen.main.bounds.width * 0.95, height: 7)
                    
                    TextField(" Price ($)", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                        .font(.system(size : 18, weight : .semibold))
                        .autocapitalization(.none)
                        .frame(height : UIScreen.main.bounds.height * 0.05)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.systemDefaultGray)
                        .frame(width : UIScreen.main.bounds.width * 0.95, height: 7)
                }.padding(.horizontal, 20)
                HStack {
                    Button {
                        viewModel.showCampPicker = true
                    } label : {
                        HStack {
                            Text("Camp")
                            if !viewModel.selectedCamps.isEmpty {
                                Image(systemName : "checkmark.circle.fill")
                                    .foregroundColor(.mainTheme)
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.systemDefaultGray)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    Spacer()
                    Button {
                        viewModel.showCategoryPicker = true
                    } label : {
                        HStack {
                            Text("Category")
                            if viewModel.selectedCategory != "" {
                                Image(systemName : "checkmark.circle.fill")
                                    .foregroundColor(.mainTheme)
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.systemDefaultGray)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }.padding(10)
            }
            
            TextField("Please write the content of your Post", text: $viewModel.description)
                .autocapitalization(.none)
                .frame(maxWidth : .infinity, minHeight : UIScreen.main.bounds.height * 0.2, maxHeight : .infinity)
                .background(Color.systemDefaultGray)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)

            Button {
                // API Call
                print(viewModel.title)
                print(viewModel.price)
                print(viewModel.description)
                print(viewModel.selectedCamps)
                print(viewModel.selectedCategory)
                viewModel.upload()
                
                withAnimation {
                    //self.isProgressShow = true
                }
            } label : {
                Text("DONE")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.07)
                    .background(Color.mainTheme)
                    .cornerRadius(30)
            }
        }
        .onChange(of: viewModel.isUploadDone, perform: { _ in
            self.presentationMode.wrappedValue.dismiss()
            self.isModifyDone = true
        })
        .navigationBarTitle(Text("Modify your post"), displayMode: .inline)
        .sheet(isPresented: $viewModel.showCampPicker) {
            NavigationView {
                List {
                    ForEach(viewModel.camps, id: \.self) { camp in
                        HStack {
                            Text(camp)
                            Spacer()
                            if viewModel.selectedCamps.contains(viewModel.campToNum[camp]!) {
                                Image(systemName : "checkmark.circle.fill")
                                    .foregroundColor(.mainTheme)
                            }
                        }
                        .onTapGesture {
                            if viewModel.selectedCamps.contains(viewModel.campToNum[camp]!) {
                                viewModel.selectedCamps
                                    .remove(at: viewModel.selectedCamps.firstIndex(of: viewModel.campToNum[camp]!)!)
                            } else {
                                viewModel.selectedCamps.append(viewModel.campToNum[camp]!)
                            }
                            print(viewModel.selectedCamps)
                        }
                    }
                }.listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Select Camps"), displayMode: .inline)
                .navigationBarItems(trailing: Button { viewModel.showCampPicker = false } label : { Text("Done").foregroundColor(.mainTheme) } )
            }
        }
        .sheet(isPresented: $viewModel.showCategoryPicker) {
            NavigationView {
                List {
                    ForEach(viewModel.categories, id: \.self) { category in
                        HStack {
                            Text(category)
                            Spacer()
                            if viewModel.selectedCategory == category {
                                Image(systemName : "checkmark.circle.fill")
                                    .foregroundColor(.mainTheme)
                            }
                        }.onTapGesture {
                            viewModel.selectedCategory = category
                        }
                    }
                }.listStyle(GroupedListStyle())
                .navigationBarTitle(Text("Select Category"), displayMode: .inline)
                .navigationBarItems(trailing: Button { viewModel.showCategoryPicker = false } label : { Text("Done").foregroundColor(.mainTheme) } )
            }
        }
    }
}
