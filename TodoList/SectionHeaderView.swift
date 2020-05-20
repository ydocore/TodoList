//
//  SectionHeaderView.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/05/20.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    var section: Int = 0
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //HeaderViewCell.xibファイルを呼び出す関数
    class func instance() -> SectionHeaderView {
        let nib = UINib(nibName: "SectionHeaderView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? SectionHeaderView else { fatalError() }
        return view
    }
    
    //sectionのタイトルを設定する関数
    func setTitle(title: String?) {
        label.text = title
    }
    
    //右端の矢印の画像を設定する関数
    func setImage(isOpen: Bool?) {
        guard let isOpen = isOpen else {
            imageView.image = nil
            return
        }
        imageView.image = isOpen ? UIImage(named: "up-arrow") : UIImage(named: "down-arrow")
    }
    
}
