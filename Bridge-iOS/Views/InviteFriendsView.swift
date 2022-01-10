//
//  InviteFriendsView.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2022/01/10.
//

import SwiftUI

struct InviteFriendsView: View {
    var topNotation : some View {
        Text("If you invite 1 person, you can use the 'anonymous writing' in the Playground. If you invite 3 person, you can qet a 'special gift' from the Katusa Snack Bar.")
            .foregroundColor(.gray)
    }
    var invitationStatusTitle : some View {
        VStack {
            Spacer()
            VStack {
                Text("Number of people")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("you Invite")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("0")
                    .font(.system(size: 70, weight: .bold))
                    .padding(.top, 20)
            }
            .foregroundColor(.mainTheme)
            Spacer()
        }
    }
    var invitationStatus : some View {
        HStack(spacing : 50) {
            VStack(spacing : 20) {
                Image(systemName: "person")
                    .font(.system(size : 40))
                Text("-")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            VStack(spacing : 20) {
                Image(systemName: "person")
                    .font(.system(size : 40))
                Text("-")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            VStack(spacing : 20) {
                Image(systemName: "person")
                    .font(.system(size : 40))
                Text("-")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
    }
    var invitationButton : some View {
        Button {
            
        } label : {
            Text("Invite User with URL")
                .fontWeight(.light)
                .padding(10)
                .padding(.horizontal, 20)
                .background(Color.mainTheme)
                .foregroundColor(.white)
                .cornerRadius(20)
        }.padding(20)
    }
    var bottomNotation : some View {
        Text("- Number go up when the person you invite finish the registration(including e-mail confirmation)\n- You should visit Katusa Snack Bar and show this page to get a special gift")
            .foregroundColor(.gray)
    }
    
    var body: some View {
        VStack {
            topNotation
            invitationStatusTitle
            invitationStatus
            invitationButton
            bottomNotation
        }
        .padding(20)
        .navigationBarTitle(Text("Invite Friends"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
