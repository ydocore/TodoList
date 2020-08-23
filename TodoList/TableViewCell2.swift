//
//  TableViewCell2.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/05/20.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

/* Text cell setting */

import UIKit
import RealmSwift

protocol TableViewCellDelegate2 {
//    func editCell(cell: TableViewCell2)
    func cancelCell(cell: TableViewCell2)
    func addCell(cell: TableViewCell2)
}

class TableViewCell2: UITableViewCell, UITextFieldDelegate {
    
    var delegate: TableViewCellDelegate2?

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let realm = try! Realm()
//        let realmData = realm.objects(RealmData.self)
//        for (i, model) in realmData[0].todoModel.enumerated() {
//            if !model.status {
//                try! realm.write {
//                    realmData[0].todoModel[i].status = true
//                }
//                break
//            }
//        }
        let cell = (textField.superview?.superview as? TableViewCell2)!
        editCell = cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell = (textField.superview?.superview as? TableViewCell2)!
        self.delegate?.cancelCell(cell: cell)
        print("フォーカスが外れました")
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        let cell = (textField.superview?.superview as? TableViewCell2)!
//        self.delegate?.editCell(cell: cell)
//        textField.becomeFirstResponder()
//        return true
//    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let cell = (textField.superview?.superview as? TableViewCell2)!
//        self.delegate?.addCell(cell: cell)
//        print("テキストフィールド入力状態後")
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cell = (textField.superview?.superview as? TableViewCell2)!
        self.delegate?.addCell(cell: cell)
        textField.endEditing(true)
        print(textField.superview?.superview?.superview)
        return true
    }
    
}
