//
//  StepCountWidget.swift
//  SWCampus
//
//  Created by 11111 on 2017/5/3.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit
import CoreMotion

final class StepCountWidget: NSObject {
    
    static let shared = StepCountWidget.init()
    var motionManage : CMMotionManager!
    var accDataArr : NSMutableArray?
    
    private override init() {
        motionManage = CMMotionManager.init()
    }
    
    func startWithStep() {
        if !motionManage.isAccelerometerAvailable {
            print("accelerometerUnAvailable");
            return
        }else{
            motionManage.accelerometerUpdateInterval = 1.0 / 4.0
            startAccelerometer()
        }
    }
    
    func startAccelerometer() {
        if !motionManage.isAccelerometerActive {
            if accDataArr == nil {
                accDataArr = NSMutableArray.init()
            }else{
                accDataArr?.removeAllObjects()
            }
            
        }
    }
}
