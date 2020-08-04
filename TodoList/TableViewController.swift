//
//  TableViewController.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/04/27.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

/* Main file */

import UIKit
import RealmSwift

class TableViewController: UITableViewController, TableViewCellDelegate, TableViewCellDelegate2, UIPickerViewDelegate, UIPickerViewDataSource {
    func backCell(cell: TableViewCell2) {
        print("a")
    }
    
    
    
    let pickerView = UIPickerView()
    var pickerRow = 0 //PickerViewで取得するIndex
    
    @IBAction func categoryButton(_ sender: UIBarButtonItem) {
        
        let alert: UIAlertController = UIAlertController(title: "カテゴリ編集", message: "操作を選択してください", preferredStyle:  .actionSheet)
        
        //カテゴリ追加
        let addCategory: UIAlertAction = UIAlertAction(title: "カテゴリ追加", style: .default, handler:{(action: UIAlertAction!) -> Void in
            let addAlert: UIAlertController = UIAlertController(title: "カテゴリ追加", message: "カテゴリ名を入力してください", preferredStyle:  .alert)
            // OKボタン
            let addAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction!) -> Void in
                let textField = addAlert.textFields
                if textField != nil {
                    for textField:UITextField in textField! {
                        if textField.text != nil {
//                            print(textField.text!)
                            let realm = try! Realm()
//                            let realmData = realm.objects(TodoModel.self)
                            let realmData = realm.objects(RealmData.self)
                            let model = TodoModel(value: ["name": textField.text!, "open": false, "status": true])
                            try! realm.write {
//                                realm.add()
                                realmData[0].todoModel.append(model)
                            }
                            print("\n\n\n~realmData when Add Category~\n\n\(realmData)")
                            self.tableView.reloadData()
                        }
                    }
                }
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            addAlert.addAction(addAction)
            addAlert.addAction(cancelAction)
            addAlert.addTextField(configurationHandler: nil)
            self.present(addAlert, animated: true, completion: nil)
        })
        
        //カテゴリ削除
        let deleteCategory: UIAlertAction = UIAlertAction(title: "カテゴリ削除", style: .default, handler:{(action: UIAlertAction!) -> Void in
            let realm = try! Realm()
            let realmData = realm.objects(RealmData.self)
            if realmData[0].todoModel.count > 0 {
                let deleteAlert: UIAlertController = UIAlertController(title: "カテゴリ削除", message: "削除したいカテゴリを選択してください\n\n\n\n\n\n\n\n", preferredStyle:  .alert)
                let deleteAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
//                    let realm = try! Realm()
                    // let realmData = realm.objects(TodoModel.self)
//                    let realmData = realm.objects(RealmData.self)
                    try! realm.write {
                        realm.delete(realmData[0].todoModel[self.pickerRow].todoCentents)
                        realm.delete(realmData[0].todoModel[self.pickerRow])
                    }
                    print("\n\n\n~realmData when Delete Category~\n\n\(realmData)")
                    self.tableView.reloadData()
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                deleteAlert.addAction(deleteAction)
                deleteAlert.addAction(cancelAction)
                //初期値を設定
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width-145, height: 100)
                self.pickerView.delegate = self
                self.pickerView.dataSource = self
                deleteAlert.view.addSubview(self.pickerView)
                self.present(deleteAlert, animated: true, completion: nil)
            } else if realmData[0].todoModel.count == 0 {
                let deleteAlert: UIAlertController = UIAlertController(title: "エラー", message: "削除するカテゴリが存在しません", preferredStyle:  .alert)
                let deleteAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("delete error")
                })
                deleteAlert.addAction(deleteAction)
                self.present(deleteAlert, animated: true, completion: nil)
            } else {
                print("category count error")
            }
        })
        
        //キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alert.addAction(addCategory)
        alert.addAction(deleteCategory)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        deleteAll()
        
        let defaults = UserDefaults.standard
        let realm = try! Realm()
        
        // 最初の初期値を設定
        if defaults.object(forKey: "firstLaunch") as! Bool {
            let realmData = RealmData()
            let model = TodoModel(value: ["name": "やること", "open": false, "status": true])
            realmData.todoModel.append(model)
            try! realm.write {
                realm.add(realmData)
            }

            defaults.set(false, forKey: "firstLaunch")
        }
        
        //カスタムセルの読み込み
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "customCell2")
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    // ボタンセルからテキストセルに変更
    func changeCell(cell: TableViewCell) {
        let realm = try! Realm()
        let realmData = realm.objects(TodoModel.self)
        let indexPath = tableView.indexPath(for: cell)
        
        try! realm.write {
            realmData[indexPath!.section].status = false
        }
        tableView.reloadData()
    }
    
    // テキストの編集 or テキストの追加
    func addCell(cell: TableViewCell2) {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        let indexPath = tableView.indexPath(for: cell)
        let content = TodoCentents(value: ["content": cell.textField.text])
        
        // 最後の行の場合
        if indexPath!.row == realmData[0].todoModel[indexPath!.section].cellCount-1 {
            try! realm.write {
                realmData[0].todoModel[indexPath!.section].cellCount += 1
                realmData[0].todoModel[indexPath!.section].status = true
                realmData[0].todoModel[indexPath!.section].todoCentents.append(content)
            }
        //最後の行以外の場合
        } else {
            try! realm.write {
                realmData[0].todoModel[indexPath!.section].todoCentents[indexPath!.row] = content
            }
        }
        print("\n\n\n~realmData when Add Contents or Edit Contents~\n\n\(realmData)")
        tableView.reloadData()
    }
    
    // データベース全削除
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}

/*------------------------------------------------------*/

// TableView Setting
extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
//        return realmData.count
        return realmData[0].todoModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
//        if realmData[section].open { return realmData[section].cellCount }
        if realmData[0].todoModel[section].open { return realmData[0].todoModel[section].cellCount } // セクションが開いているとき
        return 0 // セクションが閉じているとき
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        // 最後の行の場合
        if indexPath.row == realmData[0].todoModel[indexPath.section].cellCount-1 {
            // ボタンセルを表示する場合
            if realmData[0].todoModel[indexPath.section].status {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
                cell.delegate = self
                return cell
            // テキストセルを表示する場合
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
                cell.delegate = self
                cell.textField.text = ""
                return cell
            }
        // 最後の行ではない場合
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
            let contents = realmData[0].todoModel[indexPath.section].todoCentents[indexPath.row]
            cell.delegate = self
            cell.textField.text = contents.content
            return cell
        }
    }
    
    // ヘッダーの設定
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        let header = SectionHeaderView.instance()
        
        header.setTitle(title: realmData[0].todoModel[section].name)
        header.section = section
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewController.toggleCategoryHeader(gestureRecognizer: ))))
        header.setImage(isOpen: realmData[0].todoModel[section].open)
        header.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.3)
//        print(header.label.text!)
//        print(header.section)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    // スワイプ削除の設定
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        if indexPath.row == realmData[0].todoModel[indexPath.section].cellCount-1 {
            return false
        } else {
            return true
        }
    }
    
    // セルの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        try! realm.write {
//            realmData[indexPath.section].todoCentents.remove(at: indexPath.row)
            realmData[0].todoModel[indexPath.section].cellCount -= 1
            realm.delete(realmData[0].todoModel[indexPath.section].todoCentents[indexPath.row])
        }
    
        print("\n\n\n~realmData when Delete Contents~\n\n\(realmData)")
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // 編集モードの切り替え
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    //sectionがタップされたら呼び出される
    @objc func toggleCategoryHeader(gestureRecognizer: UITapGestureRecognizer) {
//        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        guard let header = gestureRecognizer.view as? SectionHeaderView else { return }
        //矢印の画像をnilに設定する(nilにしないと上下矢印が一瞬重なって見えてしまう)
        header.setImage(isOpen: nil)
//        let isOepn = realmData[header.section].open
//        try! realm.write {
//            realmData[header.section].open = !isOepn
//        }
        changeIsOpen(section: header.section)
        tableView.beginUpdates()
        tableView.reloadSections([header.section], with: UITableView.RowAnimation.fade)
        tableView.endUpdates()
    }
    
    //sectionの状態を変更する関数
    func changeIsOpen(section: Int) {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        let isOpen = realmData[0].todoModel[section].open
        try! realm.write {
            realmData[0].todoModel[section].open = !isOpen
        }
    }
    
}

/*------------------------------------------------------*/

// PickerView Setting
extension TableViewController {
    
    // PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        return realmData[0].todoModel.count
    }
    
    // PickerViewの項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        print("\npicker view name[\(row)]:\n\(realmData[0].todoModel[row])")
        return realmData[0].todoModel[row].name
    }
    
    // PickerViewの項目選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
    }
    
}
