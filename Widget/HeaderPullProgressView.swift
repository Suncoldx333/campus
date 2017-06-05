//
//  HeaderPullProgressView.swift
//  SWCampus
//
//  Created by 11111 on 2016/12/18.
//  Copyright © 2016年 WanHang. All rights reserved.
//

import UIKit

public class HeaderPullProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -----GlobalVar-----
    var cell1 : UIView!
    var cell2 : UIView!
    var cell3 : UIView!
    var cell4 : UIView!
    var cell5 : UIView!
    var cell6 : UIView!
    var cell7 : UIView!
    var cell8 : UIView!
    var cell9 : UIView!
    var cell10 : UIView!
    var cell11 : UIView!
    var cell12 : UIView!
    
    var ViewWidth : CGFloat!
    var ViewHeight : CGFloat!
    
    var headinitY : CGFloat!
    
    var thirtyCos : CGFloat!
    var thirtySin : CGFloat!
    public dynamic var refreshStatus : String!
    
    //MARK: -----initUI-----
    func initUI() {
        ViewWidth = self.bounds.size.width
        ViewHeight = self.bounds.size.height
        headinitY = 60.5
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        refreshStatus = "normal"
        CreateStaLoadWith(inner: 6, outside: 12.5)
    }
    
    //MARK: -----initLoadCellLoacation-----
    func CreateStaLoadWith(inner : Double,outside : Double) {
        
        let cellLength : CGFloat = CGFloat.init(outside - inner)
        let centerRadiu : Double = inner + Double.init(cellLength)/2
        let radiuFloat : CGFloat = CGFloat.init(centerRadiu)
        
        thirtyCos = CGFloat.init(centerRadiu * cos(M_PI/6))
        thirtySin = CGFloat.init(centerRadiu * sin(M_PI/6))
        
        
        cell1 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1, y: ViewHeight - cellLength, width: 2, height: cellLength))
        cell1.layer.masksToBounds = true
        cell1.layer.cornerRadius = 1.0
        cell1.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        self .addSubview(cell1)
        
        cell2 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 + thirtySin, y: ViewHeight - cellLength - (radiuFloat - thirtyCos), width: 2, height: cellLength))
        cell2.layer.masksToBounds = true
        cell2.layer.cornerRadius = 1.0
        cell2.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell2.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI/6))
        self .addSubview(cell2)
        
        cell3 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 + thirtyCos, y: ViewHeight - cellLength - (radiuFloat - thirtySin), width: 2, height: cellLength))
        cell3.layer.masksToBounds = true
        cell3.layer.cornerRadius = 1.0
        cell3.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell3.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI/3))
        self .addSubview(cell3)
        
        cell4 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 + radiuFloat, y: ViewHeight - cellLength - radiuFloat, width: 2, height: cellLength))
        cell4.layer.masksToBounds = true
        cell4.layer.cornerRadius = 1.0
        cell4.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell4.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI_2))
        self .addSubview(cell4)
        
        cell5 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 + thirtyCos, y: ViewHeight - cellLength - (radiuFloat + thirtySin), width: 2, height: cellLength))
        cell5.layer.masksToBounds = true
        cell5.layer.cornerRadius = 1.0
        cell5.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell5.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(M_PI/3))
        self .addSubview(cell5)
        
        cell6 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 + thirtySin, y: ViewHeight - cellLength - (radiuFloat + thirtyCos), width: 2, height: cellLength))
        cell6.layer.masksToBounds = true
        cell6.layer.cornerRadius = 1.0
        cell6.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell6.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(M_PI/6))
        self .addSubview(cell6)
        
        cell7 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1, y: ViewHeight - cellLength - radiuFloat * 2, width: 2, height: cellLength))
        cell7.layer.masksToBounds = true
        cell7.layer.cornerRadius = 1.0
        cell7.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        self .addSubview(cell7)
        
        cell8 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 - thirtySin, y: ViewHeight - cellLength - (radiuFloat + thirtyCos), width: 2, height: cellLength))
        cell8.layer.masksToBounds = true
        cell8.layer.cornerRadius = 1.0
        cell8.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell8.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI/6))
        self .addSubview(cell8)
        
        cell9 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 - thirtyCos, y: ViewHeight - cellLength - (radiuFloat + thirtySin), width: 2, height: cellLength))
        cell9.layer.masksToBounds = true
        cell9.layer.cornerRadius = 1.0
        cell9.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell9.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI/3))
        self .addSubview(cell9)
        
        cell10 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 - radiuFloat, y: ViewHeight - cellLength - radiuFloat, width: 2, height: cellLength))
        cell10.layer.masksToBounds = true
        cell10.layer.cornerRadius = 1.0
        cell10.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell10.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(-M_PI_2))
        self .addSubview(cell10)
        
        cell11 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 - thirtyCos, y: ViewHeight - cellLength - (radiuFloat - thirtySin), width: 2, height: cellLength))
        cell11.layer.masksToBounds = true
        cell11.layer.cornerRadius = 1.0
        cell11.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell11.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(M_PI/3))
        self .addSubview(cell11)
        
        cell12 = UIView.init(frame: CGRect.init(x: ViewWidth/2 - 1 - thirtySin, y: ViewHeight - cellLength - (radiuFloat - thirtyCos), width: 2, height: cellLength))
        cell12.layer.masksToBounds = true
        cell12.layer.cornerRadius = 1.0
        cell12.backgroundColor = ColorMethodho(hexValue: 0xb2b2b2)
        cell12.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(M_PI/6))
        self .addSubview(cell12)
        
        hideAllCell()
    }
    
    //MARK: -----hideAllCell-----
    func hideAllCell() {
        cell1.isHidden = true
        cell2.isHidden = true
        cell3.isHidden = true
        cell4.isHidden = true
        cell5.isHidden = true
        cell6.isHidden = true
        cell7.isHidden = true
        cell8.isHidden = true
        cell9.isHidden = true
        cell10.isHidden = true
        cell11.isHidden = true
        cell12.isHidden = true
    }
    
    public func changeData(offset : CGFloat) {
        if offset < -7 {
            headProgress(num: offset)
        }
    }
    
    //MARK: -----changCellStatus-----
    
    func headProgress(num : CGFloat) {
        if num > -55 {
            if num < -7 && num > -11 {
                cell7.isHidden = false
                cell6.isHidden = true
                cell5.isHidden = true
                cell4.isHidden = true
                cell3.isHidden = true
                cell2.isHidden = true
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -11 && num > -15 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = true
                cell4.isHidden = true
                cell3.isHidden = true
                cell2.isHidden = true
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -15 && num > -19 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = true
                cell3.isHidden = true
                cell2.isHidden = true
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -19 && num > -23 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = true
                cell2.isHidden = true
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -23 && num > -27 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = true
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -27 && num > -31 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = true
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -31 && num > -35 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = true
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -35 && num > -39 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = false
                cell11.isHidden = true
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -39 && num > -43 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = false
                cell11.isHidden = false
                cell10.isHidden = true
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -43 && num > -47 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = false
                cell11.isHidden = false
                cell10.isHidden = false
                cell9.isHidden = true
                cell8.isHidden = true
            }else if num < -47 && num > -51 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = false
                cell11.isHidden = false
                cell10.isHidden = false
                cell9.isHidden = false
                cell8.isHidden = true
            }else if num < -51 && num > -55 {
                cell7.isHidden = false
                cell6.isHidden = false
                cell5.isHidden = false
                cell4.isHidden = false
                cell3.isHidden = false
                cell2.isHidden = false
                cell1.isHidden = false
                cell12.isHidden = false
                cell11.isHidden = false
                cell10.isHidden = false
                cell9.isHidden = false
                cell8.isHidden = false
            }
            changeCenter(num: num)
        }else{
            changeCenter(num: -55)
            if refreshStatus == "decelerate"{
                refreshStatus = "preLoad"
            }
            hideAllCell()
        }
    }
    
    func changeCenter(num : CGFloat) {
        let initcenterx = self.center.x
        let newcentery = headinitY + CGFloat.init(0.6 * num)
        self.center = CGPoint.init(x: initcenterx, y: newcentery)
    }
    
}
