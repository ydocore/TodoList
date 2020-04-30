//
//  TableViewController.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/04/27.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

var viewModel = ViewModel()

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.tableFooterView = UIView(frame: .zero)
        addSectionContents()
    }
    
    //最初に表示するデータを定義する関数
    func addSectionContents() {
        viewModel.addSectionContent(content: SectionContents(categoryTitle: "やること1", isOpen: true, cellTitles: ["A","B"]))
        viewModel.addSectionContent(content: SectionContents(categoryTitle: "やること2", isOpen: true, cellTitles: ["C","D"]))
        viewModel.addSectionContent(content: SectionContents(categoryTitle: "やること3", isOpen: true, cellTitles: ["E","F"]))
    }
    
    //sectionがタップされたら実行される関数
    @objc func toggleCategoryHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? HeaderView else { return }
        //矢印の入れ替わりをスムーズにするためにImageをnilにする
        header.setImage(isOpen: nil)
        viewModel.changeIsOpen(section: header.section)
        
        tableView.beginUpdates()
        tableView.reloadSections([header.section], with: viewModel.currentAnimation)
        tableView.endUpdates()
    }
    

    // MARK: - Table view data source

    //sectionの数を返す関数
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.sectionCount()
    }

    //section内のcellの数を返す関数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.rowCount(section: section)
    }
    
    //cellを生成しその中身を設定する関数
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = cellTitleForRowAtIndexPath(indexPath)
        return cell
    }
    
    //sectionの高さを設定する関数
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView.instance()
        header.setTitle(title: viewModel.categoryTitle(section: section))
        header.section = section
        header.setImage(isOpen: viewModel.isOpen(section: section))
        header.backgroundColor = UIColor.white
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TableViewController.toggleCategoryHeader(gestureRecognizer:))))
        return header
    }
    
    //section内のcellの数を返す関数
    private func cellTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        return viewModel.cellTitle(indexPath: indexPath)
    }
}
