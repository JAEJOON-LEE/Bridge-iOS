//
//  FindPasswordViewModel.swift
//  Bridge-iOS
//
//  Created by Park Gyurim on 2021/11/04.
//

import Foundation
import Combine
import Alamofire

final class FindPasswordViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var buttonAction : Int = 0
    @Published var code : String = ""
    @Published var showPassword : Bool = false
    @Published var showPasswordConfirmation : Bool = false
    @Published var password : String = ""
    @Published var passwordConfirmation : String = ""
    
    
    var titleText : String {
        switch buttonAction {
        case 0:
            return "Reset Password"
        case 1 :
            return "Check your mail box"
        case 2 :
            return "Enter your new Password"
        default:
            return "get Error"
        }
    }
    
    var textFieldText : String {
        switch buttonAction {
        case 0:
            return "E-mail"
        case 1 :
            return "Enter your code"
        case 2 :
            return "Password"
        default:
            return "get Error"
        }
    }
}
