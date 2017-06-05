//
//  ImagePickerTypeChooseView.swift
//  SWCampus
//
//  Created by 11111 on 2017/2/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

@objc(pickerTypeChosenDelegate)
protocol pickerTypeChosenDelegate {
    func presentPicker(ipcType : Int)
}

public class ImagePickerTypeChooseView: UIView,ActSheetDelegate {

    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sheetView : ActSheetView!
    var delegate : pickerTypeChosenDelegate! = nil
    
    func initUI() {
        self.backgroundColor = UIColor.clear
        
        let first : NSMutableDictionary = makeSheetTitleDic(title: "拍照", titleFont: "17", titleColor: "333333")
        let second : NSMutableDictionary = makeSheetTitleDic(title: "从手机相册选择", titleFont: "17", titleColor: "333333")
        let third : NSMutableDictionary = makeSheetTitleDic(title: "取消", titleFont: "17", titleColor: "333333")
        var formatArrSwift : [NSMutableDictionary]! = []
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            formatArrSwift.append(first)
        }

        formatArrSwift.append(second)
        formatArrSwift.append(third)
        
        sheetView = ActSheetView.initWithFrame(CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), info: nil, actionArr: formatArrSwift)
        sheetView.ownner = "map"
        sheetView.curstate = 10091
        sheetView.delegate = self
        addActSheet()
    }
    
    public func addActSheet() {
        self.addSubview(sheetView)
    }
    
    public func tap(atIndex index: String!, withState state: Int32) {
        if state == 10091 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                if index == "1" {
                    showCamera()
                }else if index == "2" {
                    showPicLib()
                }
            }else{
                if index == "1" {
                    showPicLib()
                }
            }
            self.removeFromSuperview()
        }
    }
    
    func showCamera() {
        delegate.presentPicker(ipcType: 0)
        
    }
    
    func showPicLib() {
        delegate.presentPicker(ipcType: 1)
    }
    
}
