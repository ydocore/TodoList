//
//  RealmData.swift
//  TodoList
//
//  Created by 加瀬裕大 on 2020/07/24.
//  Copyright © 2020 Swift-Biginners. All rights reserved.
//

import RealmSwift

class RealmData: Object {
    let todoModel = List<TodoModel>()
}

class TodoModel: Object {
    @objc dynamic var name = "" // セクション名
    @objc dynamic var open = Bool() // セクションが空いてるか否か
    @objc dynamic var status = Bool() // 最後のセルのステータス
    @objc dynamic var cellCount = 1 // セルの数
    
    let todoCentents = List<TodoCentents>() // セルの中身のリスト
}

class TodoCentents: Object {
    @objc dynamic var content = "" // セルの中身
}

