//
//  UserSuggestionView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/02/03.
//

import SwiftUI

struct UserSuggestionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = UserSuggestionViewModel()
    
//    @State var selectedCategory : Int = 1
//    @State var textToSend : String = ""
    
//    @State var payloadImage1 : UIImage? = nil
//    @State var payloadImage2 : UIImage? = nil
//    @State var payloadImage3 : UIImage? = nil
//
//    @State var showImagePicker1 : Bool = false
//    @State var showImagePicker2 : Bool = false
//    @State var showImagePicker3 : Bool = false
    
    var TextArea : some View {
        VStack {
            Text("Beloved Users,").foregroundColor(.mainTheme)
            Text("If you have any suggestions or ideas to")
            Text("make our platform better, please let us")
            Text("know. You can write anything down below.")
        }.font(.system(.body, design: .rounded))
        .foregroundColor(.gray)
    }
    var CategorySelector : some View {
        VStack {
            HStack {
                Button {
                    withAnimation { viewModel.selectedCategory = 1 }
                } label : {
                    Text("Idea")
                        .font(.system(.body, design: .rounded))
                        .frame(width : UIScreen.main.bounds.width / 4, height : 30)
                        .foregroundColor(viewModel.selectedCategory == 1 ? .white : .gray)
                        .background(viewModel.selectedCategory == 1 ? Color.mainTheme : Color.systemDefaultGray)
                        .cornerRadius(20)
                }
                Spacer()
                Button {
                    withAnimation { viewModel.selectedCategory = 2 }
                } label : {
                    Text("Bug")
                        .font(.system(.body, design: .rounded))
                        .frame(width : UIScreen.main.bounds.width / 4, height : 30)
                        .foregroundColor(viewModel.selectedCategory == 2 ? .white : .gray)
                        .background(viewModel.selectedCategory == 2 ? Color.mainTheme : Color.systemDefaultGray)
                        .cornerRadius(20)
                }
                Spacer()
                Button {
                    withAnimation { viewModel.selectedCategory = 3 }
                } label : {
                    Text("Other")
                        .font(.system(.body, design: .rounded))
                        .frame(width : UIScreen.main.bounds.width / 4, height : 30)
                        .foregroundColor(viewModel.selectedCategory == 3 ? .white : .gray)
                        .background(viewModel.selectedCategory == 3 ? Color.mainTheme : Color.systemDefaultGray)
                        .cornerRadius(20)
                }
            }.frame(maxWidth : .infinity)
            
            Button {
                withAnimation { viewModel.selectedCategory = 4 }
            } label : {
                Text("Fraud Report")
                    .font(.system(.body, design: .rounded))
                    .frame(maxWidth : .infinity)
                    .frame(height : 30)
                    .foregroundColor(viewModel.selectedCategory == 4 ? .white : .gray)
                    .background(viewModel.selectedCategory == 4 ? Color.mainTheme : Color.systemDefaultGray)
                    .cornerRadius(20)
            }
        }.padding(10)
    }
    var SendTextArea : some View {
        VStack(spacing : 3) {
            TextEditor(text: $viewModel.textToSend)
                .padding(5)
                .frame(height : UIScreen.main.bounds.height * 0.2)
                .frame(maxWidth : .infinity)
                .background(Color.systemDefaultGray)
                .cornerRadius(20)
            Text("\(viewModel.textToSend.count)/70")
                .font(.callout)
                .foregroundColor(.gray)
                .frame(maxWidth : .infinity, alignment : .trailing)
        }.padding(.horizontal, 10)
    }
    var ImageSelector : some View {
        HStack {
            if let image = viewModel.payloadImage1 {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : 80, height : 80)
                    .cornerRadius(10)
                    .overlay(
                        Button {
                            withAnimation { viewModel.payloadImage1 = nil }
                        } label : {
                            Image(systemName: "xmark")
                                .font(.system(size: 11))
                                .padding(4)
                                .background(Color.black)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }.offset(x: 35, y: -35)
                    )
            } else {
                Button {
                    viewModel.showImagePicker1 = true
                } label : {
                    Image(systemName : "plus")
                        .foregroundColor(.gray)
                        .frame(width : 80, height : 80)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                }
            }
            Spacer()
            if let image = viewModel.payloadImage2 {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : 80, height : 80)
                    .cornerRadius(10)
                    .overlay(
                        Button {
                            withAnimation { viewModel.payloadImage2 = nil }
                        } label : {
                            Image(systemName: "xmark")
                                .font(.system(size: 11))
                                .padding(4)
                                .background(Color.black)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }.offset(x: 35, y: -35)
                    )
            } else {
                Button {
                    viewModel.showImagePicker2 = true
                } label : {
                    Image(systemName : "plus")
                        .foregroundColor(.gray)
                        .frame(width : 80, height : 80)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                }
            }
            Spacer()
            if let image = viewModel.payloadImage3 {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width : 80, height : 80)
                    .cornerRadius(10)
                    .overlay(
                        Button {
                            withAnimation { viewModel.payloadImage3 = nil }
                        } label : {
                            Image(systemName: "xmark")
                                .font(.system(size: 11))
                                .padding(4)
                                .background(Color.black)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }.offset(x: 35, y: -35)
                    )
            } else {
                Button {
                    viewModel.showImagePicker3 = true
                } label : {
                    Image(systemName : "plus")
                        .foregroundColor(.gray)
                        .frame(width : 80, height : 80)
                        .background(Color.systemDefaultGray)
                        .cornerRadius(10)
                }
            }
        }.padding(.horizontal, 10)
    }
    var SendButton : some View {
        Button {
            // Send API call
            viewModel.uploadUserSuggestion()
        } label : {
            Text("Send")
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(width : UIScreen.main.bounds.width * 0.7)
                .background(Color.mainTheme)
                .cornerRadius(30)
        }.padding()
    }
    var body: some View {
        VStack(spacing : 10) {
            Text("Write Feedback")
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.mainTheme)
                .padding()
            TextArea
            CategorySelector
            SendTextArea
            ImageSelector
            Spacer()
            SendButton
        }.padding()
        .gesture( DragGesture().onChanged { _ in hideKeyboard() } )
        .sheet(isPresented: $viewModel.showImagePicker1) {
            ImagePicker(image: $viewModel.payloadImage1).edgesIgnoringSafeArea(.bottom) }
        .sheet(isPresented: $viewModel.showImagePicker2) {
            ImagePicker(image: $viewModel.payloadImage2).edgesIgnoringSafeArea(.bottom) }
        .sheet(isPresented: $viewModel.showImagePicker3) {
            ImagePicker(image: $viewModel.payloadImage3).edgesIgnoringSafeArea(.bottom) }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("User Suggestion"))
        .onAppear { UITextView.appearance().backgroundColor = .clear }
        .onDisappear { UITextView.appearance().backgroundColor = nil }
        .alert(isPresented: $viewModel.isSendingDone) {
            Alert(title: Text("Thank you for your suggestion!"),
                  dismissButton: .default(Text("OK")) { presentationMode.wrappedValue.dismiss() }
            )
        }
    }
}
