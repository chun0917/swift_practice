//
//  GameView.swift
//  Bingo
//
//  Created by 呂淳昇 on 2022/5/19.
//

import UIKit
import Combine

class GameView: UIViewController {

    @IBOutlet weak var segGameMode: UISegmentedControl!
    @IBOutlet weak var lbLines: UILabel!
    @IBOutlet weak var lbSettingMode: UILabel!
    @IBOutlet weak var lbInputNumber: UILabel!
    @IBOutlet weak var vSetting: UIView!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var txfNumber: UITextField!
    @IBOutlet weak var cvBingoPlate: UICollectionView!
    @IBOutlet weak var cvBingoPlateLayout: UICollectionViewFlowLayout!
    
    var vNavigationBar:UIView?
    var btnBack:UIButton?
    var gameViewModel: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setDelegateAndDatasourse()
        registerCell()
        setCollectionViewLayout()
        addNavigationBar()
        bindingUIControlEvent()
        setDataBinding()
    }
    func initView(){
        segGameMode.selectedSegmentIndex = 0
        segGameMode.setTitle(LocalizadString(case: .settingMode), forSegmentAt: 0)
        segGameMode.setTitle(LocalizadString(case: .gamingMode), forSegmentAt: 1)
        lbSettingMode.text = LocalizadString(case: .settingMode)
        lbInputNumber.text = LocalizadString(case: .inputNumber)
        btnRandom.setTitle(LocalizadString(case: .random), for: .normal)
        vSetting.backgroundColor = .systemGray6
    }
    
    func setDelegateAndDatasourse(){
        cvBingoPlate.delegate = self
        cvBingoPlate.dataSource = self
    }
    
    func registerCell(){
        let bingoNib = UINib(nibName: "BingoPlateCollectionViewCell", bundle: nil)
        self.cvBingoPlate!.register(bingoNib, forCellWithReuseIdentifier: "BingoPlateCollectionViewCell")
    }
    
    func setCollectionViewLayout() {
        cvBingoPlate.isScrollEnabled = false
        cvBingoPlateLayout.estimatedItemSize = .zero
        cvBingoPlateLayout.minimumLineSpacing = 5   // 橫的
        cvBingoPlateLayout.minimumInteritemSpacing = 5  // 直的
        let cellSize = (Int(cvBingoPlate.bounds.size.width) - Int(cvBingoPlateLayout!.minimumInteritemSpacing)*(gameViewModel.size - 1))/gameViewModel.size
        cvBingoPlateLayout.itemSize = CGSize(width: cellSize, height: cellSize)
    }
    
    func bindingUIControlEvent(){
        txfNumber.publisher(for: .editingDidBegin).sink{ [unowned self] _ in
            addGestureRecognizer()
        }.store(in: &gameViewModel.uiObservers)
        
        segGameMode.publisher(for:.valueChanged).sink { [unowned self] _ in
            gameViewModel.setGameMode(selectedSegmentIndex: segGameMode.selectedSegmentIndex)
        }.store(in: &gameViewModel.uiObservers)
        
        btnRandom.publisher(for:.touchUpInside).sink{ [unowned self] _ in
            gameViewModel.setRandomNumbers()
        }.store(in: &gameViewModel.uiObservers)
        
        btnBack?.publisher(for: .touchUpInside).sink{ [self] _ in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &gameViewModel.uiObservers)
    }
    
    func setDataBinding(){
        gameViewModel.$isWin.filter{ $0 == true }.sink{ [unowned self] _ in
            showAlert(title: LocalizadString(case: .win), message: "", handler: nil)
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$isPlayable.sink{ [self] playable in
            segGameMode.isUserInteractionEnabled = playable
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$gameMode.filter{ $0 == .settingMode }.sink{ [self] _ in
            vSetting.isHidden = false
            lbLines.isHidden = true
            gameViewModel.setSelectArray()
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$gameMode.filter{ $0 == .gamingMode }.sink{ [self] _ in
            vSetting.isHidden = true
            lbLines.isHidden = false
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$cellDisplayNumbers.sink{ [unowned self] _ in
            cvBingoPlate.reloadData()
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$selectArray.sink{ [unowned self] _ in
            cvBingoPlate.reloadData()
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$editingCell.filter{ $0 >= 0 }.sink{ [unowned self] index in
            guard let number = txfNumber.text else {return}
            guard number != "" else {return}
            if gameViewModel.cellDisplayNumbers.contains(txfNumber.text!){
                showAlert(title: LocalizadString(case: .numberIsExist), message: "", handler: nil)
            }else{
                if gameViewModel.numberRange.contains(Int(number)!){
                    gameViewModel.cellDisplayNumbers[index] = txfNumber.text!
                }else{
                    showAlert(title: LocalizadString(case: .numberDoesNotInRange), message: "", handler: nil)
                }
            }
        }.store(in: &gameViewModel.uiObservers)
        
        gameViewModel.$bingoLines.sink{ [self] lines in
            lbLines.text = LocalizadString(case: .lines) + "\(lines)"
        }.store(in: &gameViewModel.uiObservers)
    }
    
    func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissEditInput))
        view.addGestureRecognizer(tap)
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
        var safeAreaInset:UIEdgeInsets!
        safeAreaInset = UIApplication.shared.windows.first!.safeAreaInsets
        vNavigationBar = UIView(frame: CGRect(x: 0, y: safeAreaInset.top, width: view.bounds.width, height: 60))
        btnBack = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: (vNavigationBar?.bounds.height)!))
        btnBack?.setTitle(LocalizadString(case: .back), for: .normal)
        btnBack?.backgroundColor = .systemGray
        vNavigationBar?.addSubview(btnBack!)
        view.addSubview(vNavigationBar!)
    }
    
    @objc func dismissEditInput() {
        view.endEditing(true)
    }
}
extension GameView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameViewModel.size * gameViewModel.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BingoPlateCollectionViewCell = cvBingoPlate.dequeueReusableCell(withReuseIdentifier: "BingoPlateCollectionViewCell", for: indexPath) as! BingoPlateCollectionViewCell
        let x = Int(indexPath.row % gameViewModel.size)
        let y = Int(indexPath.row / gameViewModel.size)
        cell.setInit(viewModel: gameViewModel,
                     index: indexPath.row,
                     number: gameViewModel.cellDisplayNumbers[indexPath.row],
                     isSelected: gameViewModel.selectArray[y][x])
        cell.bindingUIControlEvent()
        return cell
    }
    
}
