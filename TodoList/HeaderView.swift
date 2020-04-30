//
//  HeaderView.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/04/28.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var section: Int = 0

    //HeaderView.xibの読み込み
    class func instance() -> HeaderView {
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? HeaderView else { fatalError() }
        return view
    }
    
    //sectionのタイトルを設定
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    //sectionの矢印を設定
    func setImage(isOpen: Bool?) {
        guard let isOpen = isOpen else {
            imageView.image = nil
            return
        }
        imageView.image = isOpen ? UIImage(named: "up-arrow") : UIImage(named: "down-arrow")
    }
    
}
