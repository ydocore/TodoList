//
//  TableViewCell.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/05/20.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func changeCell(cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    var delegate: TableViewCellDelegate?
    
    @IBOutlet weak var button: UIButton!
    @IBAction func addButton(_ sender: UIButton) {
        let cell = (button.superview?.superview as? TableViewCell)!
        self.delegate?.changeCell(cell: cell)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

