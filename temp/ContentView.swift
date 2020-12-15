//
//  ContentView.swift
//  temp
//
//  Created by 凶手 on 2020/12/14.
//  Copyright © 2020 凶手. All rights reserved.
//

import SwiftUI

func initUserData() -> [SingleToDo]
{
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "ToDoList") as? Data{
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data{
            if !item.deleted{
                output.append(SingleToDo(title: item.title, duedate: item.duedate, isChecked: item.isChecked, id: output.count))
            }
        }
    }
    return output
}
// 总视图
struct ContentView: View {
    
    var UserDate : ToDo = ToDo(date: initUserData())
    
    @State var showEditingPage = false
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView(.vertical,showsIndicators:  true){ // 竖着滚动
                    VStack{
                        ForEach(self.UserDate.ToDoList){item in
                            // item 数组中每个元素过一遍
                            if !item.deleted {
                                SingleCarView(index: item.id)
                                    .environmentObject(self.UserDate)
                                    .padding(.top)
                                    .padding(.horizontal) // 往右走走
                            }
                            
                           
                        }
                    }
                }
            .navigationBarTitle("提醒事项")
            }
            
            
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Button(action: {
                        self.showEditingPage = true
                    }
                    ){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .sheet(isPresented: self.$showEditingPage, content: {
                        EditingPage()
                            .environmentObject(self.UserDate)
                    })
                    
                }
            }
            
        }
        
        
       
    }
    
}

// 子视图用到了父视图， 同步加一个标签

struct SingleCarView: View{
    var index: Int
    @State var showEditionPage = false
    @EnvironmentObject var UseDate: ToDo
       var body: some View { // 满足view协议就返回加一个body 返回一个svoew
           HStack{
               // 小竖条
               Rectangle()
                   .frame(width:6)
                   .foregroundColor(.blue)
            
           
            Button(action: {
                self.UseDate.delete(id: self.index)
            }){
                Image(systemName: "trash")
                    .imageScale(.large)
                    .padding(.leading)
            }
               // 竖的俩个文本，头部对齐，行间距
            Button(action: {
                self.showEditionPage = true
            }){
                Group{
                    VStack(alignment:.leading,spacing: 6.0){
                        Text(self.UseDate.ToDoList[index].title)
                            .font(.headline)  // 字号
                            .foregroundColor(.black)
                            .fontWeight(.heavy)// 字重
                        Text(self.UseDate.ToDoList[index].duedate.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }.padding(.leading)
                                  // 把东西挤到左边
                        Spacer()
                }
            }
            .sheet(isPresented: self.$showEditionPage, content: {
                EditingPage(title: self.UseDate.ToDoList[self.index].title,
                    duedate: self.UseDate.ToDoList[self.index].duedate,
                    id: self.index)
                    .environmentObject(self.UseDate)
            })
            
              
               
            Image(systemName: self.UseDate.ToDoList[index].isChecked ? "checkmark.circle.fill":"square")
                   .imageScale(.large)
                   .padding(.trailing)
                   .onTapGesture{ // 点击事间
                    self.UseDate.cheak(id: self.index)
                   }
               
           }
           .frame(height:80)
           .background(Color.white)
           .cornerRadius(10)
           .shadow(radius:10,x:0,y:10)
       }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
