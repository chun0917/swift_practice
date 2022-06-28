//
//  MainVC.swift
//  SQLCipherDemo
//
//  Created by 呂淳昇 on 2022/6/28.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var tfInputName: UITextField!
    @IBOutlet weak var tfInputPhoneNumber: UITextField!
    @IBOutlet weak var tvInformation: UITableView!
    
    var contactArray = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTableView()
        loadData()
    }
    @IBAction func inputData(_ sender: Any) {
        let name = tfInputName.text ?? ""
        let phoneNumber = tfInputPhoneNumber.text ?? ""
        
        let contactValues = Contact(name: name, phoneNumber: phoneNumber)
        
        createNewContact(contactValues)
        SQLiteCommands.presentRows()
        loadData()
    
    }
    
    private func createTable(){
        let database = SQLiteDatabase.shared
        database.createTable()
    }
    
    private func createNewContact(_ contactValues:Contact){
        let contactAddToTable = SQLiteCommands.insertRow(contactValues)
        if contactAddToTable == true{
            print("contact success")
        }else{
            print("contact failed")
        }
    }
    func setTableView(){
        tvInformation.delegate = self
        tvInformation.dataSource = self
        let informationNib = UINib(nibName: "InformationTVC", bundle: nil)
        self.tvInformation.register(informationNib, forCellReuseIdentifier: "InformationTVC")
    }
    func loadData(){
        contactArray = SQLiteCommands.presentRows() ?? []
        tvInformation.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InformationTVC = self.tvInformation.dequeueReusableCell(withIdentifier: "InformationTVC", for: indexPath)as! InformationTVC
        cell.setCellInit(contactArray[indexPath.row])
        return cell
    }
    
    
}
