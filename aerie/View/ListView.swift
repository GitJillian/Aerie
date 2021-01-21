//
//  ListView.swift
//  aerie
//
//  Created by 液晶宝宝 on 2021/1/20.
//  Copyright © 2021 Christopher Ching. All rights reserved.
//

import Foundation

import SwiftUI

struct ListView:View{
    
    
    
    @ObservedObject private var model = DBOperation()
    var body : some View{
        NavigationView{
            List(model.users){user in
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    Text(user.email)
                        .font(.headline)
                    Text(user.firstName)
                        .font(.subheadline)
                    Text(user.lastName)
                        .font(.subheadline)
                }
                
            }
            .navigationBarTitle("Users")
            .onAppear(){self.model.getAllUsers()}
        }
    }
    
    
}
