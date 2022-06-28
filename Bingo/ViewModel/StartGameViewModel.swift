//
//  StartGameViewModel.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/5/20.
//

import Foundation
import Combine

class StartGameViewModel{
    var uiObservers = Set<AnyCancellable>()
    var bingoPlateSize:Int = 0
    
    func setBingoPlateSize(size:String){
        if size == ""{
            bingoPlateSize = 0
        }else{
            bingoPlateSize = Int(size)!
        }
    }
    
    func isGameBoardSizeEffective() -> Future<Bool, Error> {
        let isEffective = (bingoPlateSize >= 3 && bingoPlateSize <= 10)
        return Future { promise in
            promise(.success(isEffective))
        }
    }
}
