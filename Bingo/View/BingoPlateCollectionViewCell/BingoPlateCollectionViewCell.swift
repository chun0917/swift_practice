//
//  BingoPlateCollectionViewCell.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/5/24.
//

import UIKit

class BingoPlateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivCellColor: UIImageView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var btnSelectCell: UIButton!
    
    var index:Int!
    var gameViewModel: GameViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setInit(viewModel:GameViewModel,index:Int,number:String,isSelected:Bool){
        self.gameViewModel = viewModel
        self.index = index
        lbNumber.text = number
        
        if isSelected == true{
            setSelected()
        }else{
            setSelectable()
        }
    }
    func bindingUIControlEvent(){
        btnSelectCell.publisher(for: .touchUpInside).sink{ [unowned self] _ in
            gameViewModel.cellClick(index: index)
        }.store(in: &gameViewModel.cellObservers)
    }
    func setSelected(){
        ivCellColor.backgroundColor = .red
        lbNumber.textColor = .black
    }
    func setSelectable(){
        ivCellColor.backgroundColor = .systemGray3
        lbNumber.textColor = .black
    }
}
