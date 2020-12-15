//
//  UserDate.swift
//  temp
//
//  Created by 凶手 on 2020/12/14.
//  Copyright © 2020 凶手. All rights reserved.
//

import Foundation

var encoder = JSONEncoder()
var decoder = JSONDecoder()
// 总数据类
class ToDo: ObservableObject{ // 把总数据类声明
    @Published var ToDoList: [SingleToDo]  // 和state差不多
    var count = 0
    // z构造函数
    init(){
        self.ToDoList = []
    }
    init(date: [SingleToDo]){
        self.ToDoList = []
        for item in date{
            self.ToDoList.append(SingleToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked, id: self.count))
            count += 1
        }
    }
    // 改变ischeak
    func cheak(id: Int){
        self.ToDoList[id].isChecked.toggle()
        self.dataStore()
    }
    
    func add(date: SingleToDo){
        self.ToDoList.append(SingleToDo(title: date.title, duedate: date.duedate, id: self.count))
        self.count += 1
        self.sort()
        self.dataStore()
    }
    
    func edit(id: Int, date: SingleToDo)
    {
        self.ToDoList[id].title = date.title
        self.ToDoList[id].duedate = date.duedate
        self.ToDoList[id].isChecked = false
        self.sort()
        self.dataStore()
    }
    
    func sort() {
        self.ToDoList.sort(by: {(date1,date2) in
            return date1.duedate.timeIntervalSince1970 < date2.duedate.timeIntervalSince1970
        })
        for i in 0..<self.ToDoList.count{
            self.ToDoList[i].id=i
        }
    }
    
    func delete(id: Int)
    {
        self.ToDoList[id].deleted = true
        self.sort()
        self.dataStore()
    }
    
    func dataStore(){
        let dataStored = try! encoder.encode(self.ToDoList)
        UserDefaults.standard.set(dataStored, forKey: "ToDoList")
    }
}


struct SingleToDo: Identifiable, Codable{ // 可变的数组
    var deleted = false
    var title: String = ""
    var duedate:Date = Date()
    var isChecked:Bool = false;
    var id:Int = 0
}
