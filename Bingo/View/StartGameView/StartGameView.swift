//
//  StartGameView.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/5/19.
//

import UIKit
import Combine

class StartGameView: UIViewController {
    
    @IBOutlet weak var lbBingoGame: UILabel!
    @IBOutlet weak var lbGameRule: UILabel!
    @IBOutlet weak var txfSetBingoPlateSize: UITextField!
    @IBOutlet weak var btnStartGame: UIButton!
    
    var startGameViewModel = StartGameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindingUIControlEvent()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        startGameViewModel.bingoPlateSize = 0
    }
    func initView(){
        lbBingoGame.text = LocalizadString(case: .bingoGame)
        lbGameRule.text = LocalizadString(case: .gameRule)
        btnStartGame.setTitle(LocalizadString(case: .startGame), for: .normal)
    }
    func bindingUIControlEvent() {
        txfSetBingoPlateSize.publisher(for: .editingDidBegin).sink{ [unowned self] _ in
            addGestureRecognizer()
        }.store(in: &startGameViewModel.uiObservers)
        
        txfSetBingoPlateSize.publisher(for: .editingDidEnd).sink{
            [unowned self] _ in
            startGameViewModel.setBingoPlateSize(size: txfSetBingoPlateSize.text!)
        }.store(in: &startGameViewModel.uiObservers)
        
        btnStartGame.publisher(for: .touchUpInside).sink { [unowned self] _ in
            let _:() = startGameViewModel.isGameBoardSizeEffective()
                .filter { $0 == true }
                .sink { _ in
                    //
                } receiveValue: { [self] _ in
                    pushToGameView()
                }.cancel()
            let _: () = startGameViewModel.isGameBoardSizeEffective()
                .filter{ $0 == false }
                .sink { _ in
                    //
                } receiveValue: { [unowned self] _ in
                    showAlert(title: LocalizadString(case: .alertGameRule), message: "", handler: nil)
                }.cancel()
        }.store(in: &startGameViewModel.uiObservers)
    }
    
    func pushToGameView(){
        let gameView = GameView()
        gameView.gameViewModel = GameViewModel.init(bingoPlateSize: startGameViewModel.bingoPlateSize)
        print(gameView.gameViewModel.size)
        self.navigationController?.pushViewController(gameView, animated: true)
    }
    
    // 加入手勢監聽
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissEditInput))
        view.addGestureRecognizer(tap)
    }
    
    // 關閉鍵盤
    @objc func dismissEditInput() {
        view.endEditing(true)
    }
}
