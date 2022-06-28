//
//  InformationTVC.swift
//  SQLCipherDemo
//
//  Created by 呂淳昇 on 2022/6/28.
//

import UIKit

class InformationTVC: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellInit(_ contact:Contact){
        lbName.text = contact.name
        lbPhoneNumber.text = contact.phoneNumber
    }
}
