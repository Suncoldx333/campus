//
//  FooterPullProgressView.swift
//  SWCampus
//
//  Created by 11111 on 2016/12/18.
//  Copyright © 2016年 WanHang. All rights reserved.
//

import UIKit

public class FooterPullProgressView: UIView {
    
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
    
    var footinitY : CGFloat!
    
    var thirtyCos : CGFloat!
    var thirtySin : CGFloat!
    
    public dynamic var footRefrshStatus : String!
    
    //MARK: -----initUI-----
    func initUI() {
        ViewWidth = self.bounds.size.width
        ViewHeight = self.bounds.size.height
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        footRefrshStatus = "normal"
        CreateStaLoadWith(inner: 5, outside: 10)
    }
    
    //MARK: -----initLoadCellLoacation-----
    func CreateStaLoadWith(inner : Double,outside : Double) {
        
        footinitY = self.center.y
        
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
    
    func changeData(offset : CGFloat) {
        
        if offset > 12 {
            changeStaLoad(num: offset)
        }
    }
    
    //MARK: -----changCellStatus-----
    public func changeStaLoad(num : CGFloat){
        
        if num < 61 {
            if num > 12 && num < 16 {
                cell1.isHidden = false
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
            }else if num > 16 && num < 20 {
                cell1.isHidden = false
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
                cell12.isHidden = false
            }else if num > 20 && num < 24 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = true
                cell7.isHidden = true
                cell8.isHidden = true
                cell9.isHidden = true
                cell10.isHidden = true
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 24 && num < 28 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = true
                cell7.isHidden = true
                cell8.isHidden = true
                cell9.isHidden = true
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 28 && num < 32 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = true
                cell7.isHidden = true
                cell8.isHidden = true
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 32 && num < 36 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = true
                cell7.isHidden = true
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 36 && num < 40 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = true
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 40 && num < 44 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = true
                cell6.isHidden = false
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 44 && num < 48 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = true
                cell5.isHidden = false
                cell6.isHidden = false
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 48 && num < 52 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = true
                cell4.isHidden = false
                cell5.isHidden = false
                cell6.isHidden = false
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 52 && num < 56 {
                cell1.isHidden = false
                cell2.isHidden = true
                cell3.isHidden = false
                cell4.isHidden = false
                cell5.isHidden = false
                cell6.isHidden = false
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }else if num > 56 && num < 60 {
                cell1.isHidden = false
                cell2.isHidden = false
                cell3.isHidden = false
                cell4.isHidden = false
                cell5.isHidden = false
                cell6.isHidden = false
                cell7.isHidden = false
                cell8.isHidden = false
                cell9.isHidden = false
                cell10.isHidden = false
                cell11.isHidden = false
                cell12.isHidden = false
            }
            changeFootCenter(num: num)
        }else{
            changeFootCenter(num: 60)
            hideAllCell()
        }
    }
    
    func changeFootCenter(num : CGFloat) {
        let initcenterx = self.center.x
        let newcentery = footinitY + CGFloat.init(0.45 * num)
        self.center = CGPoint.init(x: initcenterx, y: newcentery)
        
    }
    
}
