//
//  Localizable.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/6/2.
//

import Foundation

enum Localization:String{
    case bingoGame = "Bingo Game"
    case gameRule = "Please enter the number between 3 and 10."
    case startGame = "Start Game"
    case alertGameRule = "The range of bingo plate is between 3 and 10."
    
    case settingMode = "Setting"
    case gamingMode = "Gaming"
    case inputNumber = "Input number between 1 and 200."
    case random = "Random"
    case numberDoesNotInRange = "The number is out of range. Please input again."
    case numberIsExist = "The number is already exist. Please input again."
    case lines = "Lines:"
    case back = "Back"
    case win = "You win!"
    case alertOK = "OK"
}
func LocalizadString(case: Localization) -> String {
    return NSLocalizedString(`case`.rawValue, comment: "")
}
