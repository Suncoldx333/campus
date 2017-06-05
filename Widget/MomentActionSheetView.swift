//
//  MomentActionSheetView.swift
//  SWCampus
//
//  Created by 11111 on 2017/2/7.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

@objc (momentActionSheetDelegate)
protocol momentActionSheetDelegate {
    func reportMoment(mid : String)  //删除，英文名名错误
    func realReportMoment(mid : String,reason : String)  //举报
}

public class MomentActionSheetView: UIView,ActSheetDelegate {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var momentActionInfo : NSMutableDictionary{ //数据源
        get{
            return self.momentActionInfo
        }
        set(infoDic){
            self.makeFirstSheet(sheetDic: infoDic)
        }
    }
    var sheetView : ActSheetView!
    var reportSheetView : ActSheetView!
    var delegate : momentActionSheetDelegate! = nil
    var myMoment : Bool!
    var selectedMid : String!
    var bgWindow : UIWindow = UIWindow.init()
    
    func initUI() {
        
        bgWindow.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        bgWindow.backgroundColor = UIColor.clear
        bgWindow.windowLevel = UIWindowLevelAlert
        
        self.backgroundColor = UIColor.clear
    }
    
    public func addActSheet() {
        self.addSubview(sheetView)
    }
    
    func makeFirstSheet(sheetDic : NSMutableDictionary) {
        
        let mine : String = sheetDic.object(forKey: "mine") as! String
        selectedMid = sheetDic.object(forKey: "mid") as! String
        
        let first : NSMutableDictionary = makeSheetTitleDic(title: "举报", titleFont: "17", titleColor: "333333")
        let second : NSMutableDictionary = makeSheetTitleDic(title: "删除", titleFont: "17", titleColor: "333333")
        let third : NSMutableDictionary = makeSheetTitleDic(title: "取消", titleFont: "17", titleColor: "333333")
        var formatArrSwift : [NSMutableDictionary]! = []
        
        if mine == "1" {
            myMoment = true
            formatArrSwift.append(first)
            formatArrSwift.append(second)
            formatArrSwift.append(third)
        }else{
            myMoment = false
            formatArrSwift.append(first)
            formatArrSwift.append(third)
        }
        
        sheetView = ActSheetView.initWithFrame(CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), info: nil, actionArr: formatArrSwift)
        sheetView.ownner = "map"
        sheetView.curstate = 10092
        sheetView.delegate = self
        
        self.addSubview(sheetView)
        
        bgWindow.isHidden = false
        bgWindow.addSubview(self)
    }
    
    public func tap(atIndex index: String!, withState state: Int32) {
        if state == 10092 {
            if myMoment == true {
                if index == "1" {
                    showReportSheet()
                }else if index == "2" {
                    print("删除")
//                    self.removeFromSuperview()
                    bgWindow.isHidden = true
                    delegate.reportMoment(mid: selectedMid)
                }else{
//                    self.removeFromSuperview()
                    bgWindow.isHidden = true
                }
            }else{
                if index == "1" {
                    showReportSheet()
                }else{
//                    self.removeFromSuperview()
                    bgWindow.isHidden = true
                }
            }
        }else if state == 10091 {
            if index == "1" {
                delegate.realReportMoment(mid: selectedMid, reason: "不友善内容（色情、辱骂等）")
//                self.removeFromSuperview()
                bgWindow.isHidden = true
            }else if index == "2" {
                delegate.realReportMoment(mid: selectedMid, reason: "垃圾广告、推销")
//                self.removeFromSuperview()
                bgWindow.isHidden = true
            }else if index == "3" {
                delegate.realReportMoment(mid: selectedMid, reason: "其它")
//                self.removeFromSuperview()
                bgWindow.isHidden = true
            }else{
//                self.removeFromSuperview()
                bgWindow.isHidden = true
            }
            
        }
    }
    
    func showReportSheet() {
        createReportSheet()
    }
    
    func createReportSheet() {
        let first : NSMutableDictionary = makeSheetTitleDic(title: "不友善内容（色情、辱骂等）", titleFont: "17", titleColor: "333333")
        let second : NSMutableDictionary = makeSheetTitleDic(title: "垃圾广告、推销", titleFont: "17", titleColor: "333333")
        let third : NSMutableDictionary = makeSheetTitleDic(title: "其它", titleFont: "17", titleColor: "333333")
        let forth : NSMutableDictionary = makeSheetTitleDic(title: "取消", titleFont: "17", titleColor: "333333")
        var formatArrSwift : [NSMutableDictionary]! = []
        
        formatArrSwift.append(first)
        formatArrSwift.append(second)
        formatArrSwift.append(third)
        formatArrSwift.append(forth)
        
        reportSheetView = ActSheetView.initWithFrame(CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), info: nil, actionArr: formatArrSwift)
        reportSheetView.ownner = "map"
        reportSheetView.curstate = 10091
        reportSheetView.delegate = self
        
        self.addSubview(reportSheetView)
    }
}
