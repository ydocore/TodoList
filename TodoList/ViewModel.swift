//
//  ViewModel.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/04/08.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

struct SectionContents {
    var categoryTitle: String?
    var isOpen: Bool = false
    var cellTitles: [String]?
    
    init(categoryTitle: String? = "", isOpen: Bool = true, cellTitles: [String]? = []) {
        self.categoryTitle = categoryTitle
        self.isOpen = isOpen
        self.cellTitles = cellTitles
    }
}

class ViewModel {
    
    //アコーディオンメニューのアニメーションを設定
    var currentAnimation = UITableView.RowAnimation.fade
    
    private var sectionContents: [SectionContents] = []
    
    //sectionの数を返す関数
    func sectionCount() -> Int {
        return sectionContents.count
    }
    
    //cellの数をか返す関数
    func rowCount(section: Int) -> Int {
        if sectionCount() == 0 { return 0 }
        if sectionContents[section].isOpen { return sectionContents[section].cellTitles?.count ?? 0 }
        return 0
    }
    
    //sectionのタイトルを返す関数
    func categoryTitle(section: Int) -> String? {
        if sectionCount() == 0 { return nil }
        return sectionContents[section].categoryTitle
    }
    
    //cellの内容を返す関数
    func cellTitle(indexPath: IndexPath) -> String? {
        if sectionCount() == 0 { return nil }
        if let genreTitles = sectionContents[indexPath.section].cellTitles {
            return genreTitles[indexPath.row]
        }
        return nil
    }
    
    //sectionを追加する関数
    func addSectionContent(content: SectionContents) {
        sectionContents.append(content)
    }
    
    //cellを追加する関数
    func addCellContent(section: Int, content: String) {
        sectionContents[section].cellTitles?.append(content)
    }
    
    //sectionが空いているかを返す関数
    func isOpen(section: Int) -> Bool {
        if sectionContents.isEmpty { return false }
        return sectionContents[section].isOpen
    }
    
    //sectionの状態を変更する関数
    func changeIsOpen(section: Int) {
        if sectionContents.isEmpty { return }
        let isOpen = sectionContents[section].isOpen
        sectionContents[section].isOpen = !isOpen
    }
}
