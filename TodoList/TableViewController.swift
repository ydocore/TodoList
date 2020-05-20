//
//  TableViewController.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/04/27.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, TableViewCellDelegate, TableViewCellDelegate2 {
    
    let pickerView = UIPickerView()
    
    var TodoSection = ["1", "2", "3"]
    var TodoContents = [["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]]
    var sectionOpen = [true, true, true]
    var cellStatus = [true, true, true]
    var cellCount = [4, 4, 4]
    var pickerRow = 0
    
    @IBAction func categoryButton(_ sender: UIBarButtonItem) {
        let alert: UIAlertController = UIAlertController(title: "カテゴリ編集", message: "操作を選択してください", preferredStyle:  .actionSheet)
        
        //カテゴリ追加
        let addCategory: UIAlertAction = UIAlertAction(title: "カテゴリ追加", style: .default, handler:{(action: UIAlertAction!) -> Void in
            let addAlert: UIAlertController = UIAlertController(title: "カテゴリ追加", message: "カテゴリ名を入力してください", preferredStyle:  .alert)
            let addAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction!) -> Void in
                let textField = addAlert.textFields
                if textField != nil {
                    for textField:UITextField in textField! {
                        if textField.text != nil {
                            print(textField.text!)
                            self.TodoSection.append(textField.text!)
                            self.sectionOpen.append(true)
                            self.cellStatus.append(true)
                            self.TodoContents.append([])
                            self.cellCount.append(1)
                            self.tableView.reloadData()
                        }
                    }
                }
            })
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
            let deleteAlert: UIAlertController = UIAlertController(title: "カテゴリ削除", message: "削除したいカテゴリを選択してください\n\n\n\n\n\n\n\n", preferredStyle:  .alert)
            let deleteAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.TodoSection.remove(at: self.pickerRow)
                self.sectionOpen.remove(at: self.pickerRow)
                self.cellStatus.remove(at: self.pickerRow)
                self.TodoContents.remove(at: self.pickerRow)
                self.cellCount.remove(at: self.pickerRow)
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
            deleteAlert.view.addSubview(self.pickerView)
            
            self.present(deleteAlert, animated: true, completion: nil)
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
        
        //カスタムセルの読み込み
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "customCell2")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //sectionがタップされたら呼び出される
    @objc func toggleCategoryHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? SectionHeaderView else { return }
        //矢印の画像をnilに設定する(nilにしないと上下矢印が一瞬重なって見えてしまう)
        header.setImage(isOpen: nil)
        changeIsOpen(section: header.section)
        tableView.beginUpdates()
        tableView.reloadSections([header.section], with: UITableView.RowAnimation.fade)
        tableView.endUpdates()
    }
    
    //sectionの状態を変更する関数
    func changeIsOpen(section: Int) {
        let isOpen = sectionOpen[section]
        sectionOpen[section] = !isOpen
    }
    
    //sectionの中身の数をカウントする関数
    func rowCount(section: Int) -> Int {
        if TodoSection.count == 0 { return 0 }
        // 開いているセクションだったらgenre分の個数を返す
        if sectionOpen[section] { return cellCount[section] }
        // 開いてないセクションだったら0
        return 0
    }
    
    func changeCell(cell: TableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        cellStatus[indexPath!.section] = false
        tableView.reloadData()
    }
    
    func addCell(cell: TableViewCell2) {
        let indexPath = tableView.indexPath(for: cell)
        if indexPath!.row == cellCount[indexPath!.section]-1 {
            TodoContents[indexPath!.section].append(cell.textField.text!)
            cellCount[indexPath!.section] += 1
            cellStatus[indexPath!.section] = true
    //        print(indexPath!)
    //        print(indexPath!.section)
    //        print(cellcount[indexPath!.section])
        } else {
            TodoContents[indexPath!.section][indexPath!.row] = cell.textField.text!
        }
        tableView.reloadData()
        print(TodoContents)
    }

}


extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoSection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cellCount[indexPath.section]-1 {
            if cellStatus[indexPath.section] {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
                cell.delegate = self
                cell.textField.text = ""
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
            cell.delegate = self
            cell.textField.text = TodoContents[indexPath.section][indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderView.instance()
        header.setTitle(title: TodoSection[section])
        header.section = section
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewController.toggleCategoryHeader(gestureRecognizer: ))))
        header.setImage(isOpen: sectionOpen[section])
        header.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 245/255, alpha: 1.0)
        print(header.label.text!)
        print(header.section)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == cellCount[indexPath.section]-1 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        TodoContents[indexPath.section].remove(at: indexPath.row)
        cellCount[indexPath.section] -= 1
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
}


extension TableViewController {
    
    // PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TodoSection.count
    }
    
    // PickerViewの項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TodoSection[row]
    }
    
    // PickerViewの項目選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
    }
    
}
