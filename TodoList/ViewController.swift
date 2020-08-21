//
//  ViewController.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/07/24.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let pickerView = UIPickerView()
    var pickerRow = 0 //PickerViewで取得するIndex
    var tapLocation: CGPoint = CGPoint()
    var cellBottom = true
    var cellRect: CGRect = CGRect()
    var lastCell = false
    
    // 広告ユニットID
    let AdMobID = "[Your AdMob ID]"
    // テスト用広告ユニットID
    let TEST_ID = "ca-app-pub-3940256099942544/2934735716"
    // true:テスト
    let AdMobTest:Bool = true
    var topPadding:CGFloat = 0
    var bottomPadding:CGFloat = 0
    var leftPadding:CGFloat = 0
    var rightPadding:CGFloat = 0

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
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
//                self.pickerView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width-145, height: 100)
                self.pickerView.frame = CGRect(x: 0, y: 50, width: 270, height: 150)
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
        
        let realmData = realm.objects(RealmData.self)
        if realmData[0].todoModel.count == 0 {
            label.isHidden = false
        } else {
            label.isHidden = true
        }
        
        //カスタムセルの読み込み
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.register(UINib(nibName: "TableViewCell2", bundle: nil), forCellReuseIdentifier: "customCell2")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
//        var admobView = GADBannerView()
//
//        bannerView = GADBannerView(adSize:kGADAdSizeBanner)
//        // iPhone X のポートレート決め打ちです
//        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - 34)
//        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
//        print(admobView.frame.height)
        
        if AdMobTest {
            bannerView.adUnitID = TEST_ID
        }
        else{
            bannerView.adUnitID = AdMobID
        }
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
//        self.view.addSubview(admobView)
        
        navigationItem.rightBarButtonItem = editButtonItem
//        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
    }
    
    override func viewDidLayoutSubviews() {
        print(self.view.safeAreaInsets.bottom)
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(self.checkSafeArea(notification:)),
//            name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
//    @objc func checkSafeArea(notification: NSNotification){
//        // 画面の横幅を取得
//        // 以降、Landscape のみを想定
//        let screenWidth:CGFloat = view.frame.size.width
//        let screenHeight:CGFloat = view.frame.size.height
//
//        if #available(iOS 13, *) {
//            let window = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?
//            .windows
//            .filter({$0.isKeyWindow})
//            .first
//
//            topPadding = window!.safeAreaInsets.top
//            bottomPadding = window!.safeAreaInsets.bottom
//            leftPadding = window!.safeAreaInsets.left
//            rightPadding = window!.safeAreaInsets.right
//
//            print("topPadding = \(topPadding)")
//            print("bottomPadding = \(bottomPadding)")
//            print("leftPadding = \(leftPadding)")
//            print("rightPadding = \(rightPadding)")
//        }
//    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        let realm = try! Realm()
//        let realmData = realm.objects(RealmData.self)
//        var count = 0
//        for model in realmData[0].todoModel {
//            if model.open == true {
//                count += model.todoCentents.count
//            }
//        }
//        print(count)
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let margin = tableView.frame.maxY - cellRect.origin.y
//            print(margin)
//            print(keyboardSize.height)
//            print(cellRect.origin.y)
//            print(tableView.frame.maxY)
//            print(self.view.frame.maxY)
            
//            if margin < keyboardSize.height {
//                if tableView.frame.origin.y == 0 {
//                    let suggestionHeight = keyboardSize.height - margin
//                    tableView.frame.origin.y -= suggestionHeight
//                } else {
//                    let suggestionHeight = tableView.frame.origin.y + keyboardSize.height - margin
//                    tableView.frame.origin.y -= suggestionHeight
//                }
//            }
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= keyboardSize.height
//                }
//                } else {
//                    let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
//                    self.view.frame.origin.y -= suggestionHeight
//                }
//            }
//        }
//    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let realm = try! Realm()
        let realmData = realm.objects(RealmData.self)
        let sectionCount = realmData[0].todoModel.count
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        var cellCount = 0
        for model in realmData[0].todoModel {
            if model.open == true {
                cellCount += model.cellCount
            }
        }
        let height: CGFloat = CGFloat(50*sectionCount + 44*cellCount)
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var tapCell: CGFloat = CGFloat()
            if lastCell {
                tapCell = cellRect.origin.y + cellRect.height
            } else {
                let rect = tableView.convert(editCell.frame, to: self.view)
                tapCell = rect.origin.y + rect.height
            }
            if tapCell > view.frame.height - keyboardSize.height {
                print("View Up!")
                let heightDifference = tapCell - (view.frame.height - keyboardSize.height)
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= heightDifference
                }
            }
            cellRect = CGRect(x:0,y:0,width:0,height:0)
            lastCell = false
//            if height > view.frame.height-(keyboardSize.height+100) && height <= view.frame.height-100 {
//                print("画面内")
//                let heightDifference = (keyboardSize.height+100) - (view.frame.height-height)
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= heightDifference
//                }
////                } else {
////                    let suggestionHeight = self.view.frame.origin.y + heightDifference
////                    self.view.frame.origin.y -= suggestionHeight
////                }
//            } else if height > view.frame.height-100 {
//                print("画面外")
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= keyboardSize.height
//                } else {
//                    let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
//                    self.view.frame.origin.y -= suggestionHeight
//                }
//            }
//            print(view.frame.height)
//            print(height)
//            print(keyboardSize.height)
//            print(navBarHeight)
        }
    }

    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: tableView)
        print(location)
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
extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        if realmData[0].todoModel.count == 0 {
            label.isHidden = false
        } else {
            label.isHidden = true
        }
//        return realmData.count
        return realmData[0].todoModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
//        if realmData[section].open { return realmData[section].cellCount }
        if realmData[0].todoModel[section].open { return realmData[0].todoModel[section].cellCount } // セクションが開いているとき
        return 0 // セクションが閉じているとき
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        
        // 最後の行の場合
        if indexPath.row == realmData[0].todoModel[indexPath.section].cellCount-1 {
            // ボタンセルを表示する場合
            if realmData[0].todoModel[indexPath.section].status {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
                cell.backgroundColor = UIColor.clear
                cell.delegate = self
                return cell
            // テキストセルを表示する場合
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
                cell.backgroundColor = UIColor.clear
                cell.delegate = self
                cell.textField.text = ""
                cell.textField.becomeFirstResponder()
                return cell
            }
        // 最後の行ではない場合
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell2", for: indexPath) as! TableViewCell2
            let contents = realmData[0].todoModel[indexPath.section].todoCentents[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            cell.textField.text = contents.content
            return cell
        }
    }
    
    // ヘッダーの設定
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let realm = try! Realm()
//        let realmData = realm.objects(TodoModel.self)
        let realmData = realm.objects(RealmData.self)
        let header = SectionHeaderView.instance()
        
        header.setTitle(title: realmData[0].todoModel[section].name)
        header.section = section
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewController.toggleCategoryHeader(gestureRecognizer: ))))
        header.setImage(isOpen: realmData[0].todoModel[section].open)
        header.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
        header.layer.borderColor = UIColor.black.cgColor
        header.layer.borderWidth = 1
//        print(header.label.text!)
//        print(header.section)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    // スワイプ削除の設定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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

/*------------------------------------------------------*/

extension ViewController: TableViewCellDelegate, TableViewCellDelegate2 {
//    func editCell(cell: TableViewCell2) {
//        let realm = try! Realm()
//        let realmData = realm.objects(RealmData.self)
//        let indexPath = tableView.indexPath(for: cell)
//        if indexPath!.row != realmData[0].todoModel[indexPath!.section].cellCount {
////            tableView.reloadData()
////            DispatchQueue.main.async {
////                self.tableView.scrollToRow(at: indexPath!, at: UITableView.ScrollPosition.bottom, animated: false)
////            }
//            cellRect = tableView.convert(cell.frame, to: self.view)
//        }
//    }
    
    // ボタンセルからテキストセルに変更
    func changeCell(cell: TableViewCell) {
        let realm = try! Realm()
        let realmData = realm.objects(RealmData.self)
        let indexPath = tableView.indexPath(for: cell)
//        tableView.convert(cell.frame, to: self.view)
//        let frame = cell.convert(tableView.rectForRow(at: indexPath!), to: self.view)
//        let frame2 = cell.frame
//        cellRect = tableView.rectForRow(at: indexPath!)
//        tableView.scrollToRow(at: indexPath!, at: UITableView.ScrollPosition.top, animated: false)
//        cellRect = frame
//        print(frame)
//        print(frame2)
//        print(cellRect)
//        print(tableView.bounds)
//        print(tableView.contentOffset)
//        print(cellRect.height)
//        print(cellRect.origin.y)
        cellRect = tableView.convert(cell.frame, to: self.view)
        print(tableView.convert(cell.frame, to: self.view))
        
        try! realm.write {
            realmData[0].todoModel[indexPath!.section].status = false
        }
        lastCell = true
        tableView.reloadData()
//        DispatchQueue.main.async {
//            self.tableView.scrollToRow(at: indexPath!, at: UITableView.ScrollPosition.bottom, animated: false)
//        }
//        let frame3 = cell.frame
//        if frame2 == frame3 {
//            cellBottom = false
//        } else {
//            cellBottom = true
//        }
        print(indexPath)
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
            if cell.textField!.text != "" {
                try! realm.write {
                    realmData[0].todoModel[indexPath!.section].cellCount += 1
                    realmData[0].todoModel[indexPath!.section].status = true
                    realmData[0].todoModel[indexPath!.section].todoCentents.append(content)
                }
            } else {
                try! realm.write {
                    realmData[0].todoModel[indexPath!.section].status = true
                }
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
}
