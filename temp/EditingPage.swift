//
//  EditingPage.swift
//  temp
//
//  Created by 凶手 on 2020/12/14.
//  Copyright © 2020 凶手. All rights reserved.
//

import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var UsrDate: ToDo
    @Environment(\.presentationMode) var presention
    @State var title: String = ""
    @State var duedate: Date = Date()
    
    var id: Int? = nil
    var body: some View {
        // 表单类似的view
        NavigationView{
            // 放一个结合视图
            Form{
                Section(header: Text("事项")){
                    TextField("事项内容", text: self.$title) // 传入的字符串绑定到title
                    DatePicker(selection: self.$duedate, label: { Text("截止时间")})
                }
                Section{
                    Button(action:{
                        if self.id == nil{
                            self.UsrDate.add(date: SingleToDo(title: self.title, duedate: self.duedate))
                        }
                        else{
                            self.UsrDate.edit(id: self.id!, date: SingleToDo(title: self.title, duedate: self.duedate))
                        }
                        self.presention.wrappedValue.dismiss()
                    }){
                         Text("确认")
                    }
                    Button(action: {
                        self.presention.wrappedValue.dismiss()
                    }
                    ){
                        Text("取消")
                    }
                    
                }
            }
        .navigationBarTitle("添加事项")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
