//
//  GameViewModel.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/5/20.
//

import Foundation
import Combine

class GameViewModel{
    
    enum BingoGameMode{
        case gamingMode
        case settingMode
    }
    
    var uiObservers = Set<AnyCancellable>()
    var cellObservers = Set<AnyCancellable>()
    
    var size:Int = 0{
        didSet{
            setSelectArray()
            setCellDisplayNumbers()
        }
    }
    var numberRange:[Int]{
        get{
            return Array(1...200)
        }
    }
    
    @Published var gameMode:BingoGameMode = .settingMode
    @Published var isPlayable:Bool = false
    @Published var editingCell:Int = -1
    @Published var bingoLines:Int = 0
    @Published var isWin:Bool = false
    @Published var selectArray =  [[Bool]](){
        didSet{
            cellObservers.removeAll(keepingCapacity: false)    // 清空 Cell 的監聽
            isWin = checkWin(array: selectArray)
        }
    }
    @Published var cellDisplayNumbers = [String](){
        didSet {
            cellObservers.removeAll(keepingCapacity: false)    // 清空 Cell 的監聽
            checkPlayable()
        }
    }
    init(bingoPlateSize:Int){
        size = bingoPlateSize
        setSelectArray()
        setCellDisplayNumbers()
    }
    
    func setGameMode(selectedSegmentIndex:Int){
        switch selectedSegmentIndex{
        case 0:
            gameMode = .settingMode
        case 1:
            gameMode = .gamingMode
        default:
            break
        }
    }
    
    func setSelectArray() {
        var temp =  [[Bool]]()
        var selectStateArray = [Bool]()
        
        for _ in 0..<size { selectStateArray.append(false) }
        for _ in 0..<size { temp.append(selectStateArray) }
        
        selectArray = temp
    }
    
    func setCellDisplayNumbers() {
        var temp =  [String]()
        
        for _ in 0..<(size * size) { temp.append("") }
        
        cellDisplayNumbers = temp
    }
    
    func setRandomNumbers(){
        var array = [String]()
        
        if cellDisplayNumbers.contains(""){
            for i in 0..<(size*size){
                if cellDisplayNumbers[i] == ""{
                    let random = String(Int.random(in: 1...200))
                    array.append(random)
                }else{
                    array.append(cellDisplayNumbers[i])
                }
            }
        }else{
            var numberCount = 0
            while numberCount <= (size*size) {
                let random = String(Int.random(in: 1...200))
                array.append(random)
                numberCount = numberCount+1
            }
        }
        cellDisplayNumbers = array
    }
    
    func checkPlayable(){
        if cellDisplayNumbers.contains(""){
            isPlayable = false
        }else{
            isPlayable = true
        }
    }
    
    func checkWin(array:[[Bool]])->Bool{
        var lines:Int = 0
        
        let win:Int = size - 1
        
        // 檢查橫排
        for i in 0..<size {
            for j in 0..<size {
                if array[i][j] == true{
                    if j == size - 1{
                        lines = lines + 1
                    }
                }else{
                    break
                }
            }
        }
        
        // 檢查直排
        for i in 0..<size {
            for j in 0..<size {
                if array[j][i] == true{
                    if j == size - 1{
                        lines = lines + 1
                    }
                }else{
                    break
                }
            }
        }
        // 檢查左上到右下對角線
        for i in 0..<size {
            if array[i][i] == true{
                if i == size - 1{
                    lines = lines + 1
                }
            }else{
                break
            }
        }

        // 檢查左下到右上對角線
        for i in 0..<size {
            if array[size - 1 - i][i] == true{
                if i == size - 1{
                    lines = lines + 1
                }
            }else{
                break
            }
        }
        print(lines)
        self.bingoLines = lines
        return lines >= win
    }
    
    func cellClick(index:Int){
        switch gameMode{
        case .settingMode:
            editingCell = index
        case .gamingMode:
            let x = Int(index % size)
            let y = Int(index / size)
            let gameSelectArray = !selectArray[y][x]
            selectArray[y][x] = gameSelectArray
            print(selectArray)
        }
    }
    
}
