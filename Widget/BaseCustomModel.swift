//
//  BaseCustomModel.swift
//  SWCampus
//
//  Created by 11111 on 2017/3/16.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

public class BaseCustomModel: NSObject {
    
    public init(changingDic : [String : Any]) {
        super.init()
        createAttribute(changingDic: changingDic)
    }
    
    func createAttribute(changingDic : [String : Any]) {
        var count : UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder, &count)
        
        for index in 0..<count {
            _ = String.init(describing: ivar_getName(ivars?[Int.init(index)]))
        }
        
    }
}
