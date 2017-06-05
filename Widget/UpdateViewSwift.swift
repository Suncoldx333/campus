//
//  UpdateViewSwift.swift
//  SWCampus
//
//  Created by WangZhaoyun on 2016/11/30.
//  Copyright © 2016年 WanHang. All rights reserved.
//

import UIKit

@objc(updateViewTapEventDelegate)
protocol updateViewTapEventDelegate {
    func clickEventWithType(btType : NSInteger)   //btType:0-强制确定，1-非强制确定，2-非强制取消
}

public class UpdateViewSwift: UIView {

    override init(frame : CGRect){
        super.init(frame: frame)

        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-----Var-----
    var updateBgWin : UIWindow = UIWindow.init()
    var updateInfoView = UIView.init()
    var updateInfoViewWidth : CGFloat = 280
    var updateInfoViewHeight : CGFloat = 300

    var titleLabel = UILabel.init()
    var subTitleLabel = UILabel.init()
    var doUpdateBt : UIButton!
    var undoUpteBt : UIButton!
    
    var updateStatus : Bool!
    
    var delegate : updateViewTapEventDelegate! = nil
    
    
    //MARK:-----UI-----
    func initUI() {
        
        updateStatus = false
        
        updateBgWin.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        updateBgWin.backgroundColor = UIColor.clear
        updateBgWin.windowLevel = UIWindowLevelAlert
        
        self.backgroundColor = ColorMethodho(hexValue: 0x333333).withAlphaComponent(0.4)
        
        
        updateInfoView.frame = CGRect.init(x: (ScreenWidth - updateInfoViewWidth)/2, y: (ScreenHeight - updateInfoViewHeight)/2, width: updateInfoViewWidth, height: updateInfoViewHeight)
        updateInfoView.layer.masksToBounds = true
        updateInfoView.layer.cornerRadius = 4
        updateInfoView.backgroundColor = ColorMethodho(hexValue: 0xffffff).withAlphaComponent(1.0)
        self.addSubview(updateInfoView)

        
        let versionInfoBgView : UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: updateInfoViewWidth, height: 175))
        versionInfoBgView.image = #imageLiteral(resourceName: "updateBgImage560350")
        updateInfoView.addSubview(versionInfoBgView)
        
        let versionInfoIconImage : UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        versionInfoIconImage.center = CGPoint.init(x: updateInfoViewWidth/2, y: 40 + 25)
        versionInfoIconImage.image = #imageLiteral(resourceName: "updateIcon100100")
        updateInfoView.addSubview(versionInfoIconImage)
        
        titleLabel.frame = CGRect.init(x: 15, y: 60 + 50, width: updateInfoViewWidth - 30, height: 13)
        titleLabel.numberOfLines = 0
        updateInfoView.addSubview(titleLabel)
        
        subTitleLabel.frame = CGRect.init(x: 15, y: versionInfoBgView.frame.maxY + 25, width: updateInfoViewWidth - 30, height: 15)
        subTitleLabel.numberOfLines = 0
        updateInfoView.addSubview(subTitleLabel)
        
        doUpdateBt = UIButton.init(type: UIButtonType.custom)
        doUpdateBt.frame = CGRect.init(x: 0, y: 0, width: 110, height: 35)
        doUpdateBt.layer.masksToBounds = true
        doUpdateBt.layer.cornerRadius = 3
        doUpdateBt .backgroundColor = ColorMethodho(hexValue: 0x00c18b)
        doUpdateBt .setTitle("立即升级", for: UIControlState.normal)
        doUpdateBt .setTitleColor(ColorMethodho(hexValue: 0xffffff), for: UIControlState.normal)
        doUpdateBt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        doUpdateBt .addTarget(self, action: #selector(jumpToAppStore), for: UIControlEvents.touchUpInside)
        updateInfoView.addSubview(doUpdateBt)
        
        undoUpteBt = UIButton.init(type: UIButtonType.custom)
        undoUpteBt .frame = CGRect.init(x: 0, y: 0, width: 110, height: 35)
        undoUpteBt.layer.masksToBounds = true
        undoUpteBt.layer.cornerRadius = 3
        undoUpteBt.layer.borderWidth = 0.5
        undoUpteBt.layer.borderColor = ColorMethodho(hexValue: 0xe6e6e6).cgColor
        undoUpteBt .setTitle("以后再说", for: UIControlState.normal)
        undoUpteBt .setTitleColor(ColorMethodho(hexValue: 0xb2b2b2), for: UIControlState.normal)
        undoUpteBt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        undoUpteBt .backgroundColor = ColorMethodho(hexValue: 0xfafafa)
        undoUpteBt .addTarget(self, action: #selector(removeUpdateView), for: UIControlEvents.touchUpInside)
    }
    
    //MARK:-----Method-----
    public func update(title : String,subTitle : String,size : String,optional : Bool){
        
        changeTitle(titlelStr: title)
        changeSubTitle(subTitle: subTitle)
        
        if optional {
            
            updateStatus = true
            
            updateInfoView.addSubview(undoUpteBt)
            undoUpteBt.frame = CGRect.init(x: 25, y: 175 + 69, width: 110, height: 35)
            let undoBtMaxX = undoUpteBt.frame.maxX
            doUpdateBt.frame = CGRect.init(x: undoBtMaxX + 10, y: 175 + 69, width: 110, height: 35)

        }else{
            
            updateStatus = false
            
            let sizeTitle = "立即升级（" + size + "M)"
            doUpdateBt.frame = CGRect.init(x: (updateInfoViewWidth - 230)/2, y: 175 + 69, width: 230, height: 35)
            doUpdateBt .setTitle(sizeTitle, for: UIControlState.normal)

        }
        
    }
    
    public func show(){
        updateBgWin.isHidden = false
        updateBgWin .addSubview(self)
    }
    
    func enterAni(aniTime : Float) {
        UIView.animate(withDuration: TimeInterval(aniTime),
                       animations: { 
                        
            }) { (true) in
                self.backgroundColor = ColorMethodho(hexValue: 0x333333).withAlphaComponent(0.4)
        }
    }
    
    func changeTitle(titlelStr : String){
     
        let Attr = NSMutableAttributedString.init(string: titlelStr)
        
        let thinFont_13 = [NSFontAttributeName : UIFont.init(name: "HelveticaNeue-Thin", size: 13)!]
        let Color = [NSForegroundColorAttributeName : ColorMethodho(hexValue: 0xffffff)]
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.center
        para.paragraphSpacing = 5.5
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        Attr .addAttributes(thinFont_13, range: NSRange.init(location: 0, length: titlelStr.characters.count))
        Attr .addAttributes(Color, range: NSRange.init(location: 0, length: titlelStr.characters.count))
        Attr.addAttributes(para_dic, range: NSRange.init(location: 0, length: titlelStr.characters.count))
        
        titleLabel.attributedText = Attr
        
        titleLabel.sizeToFit()
        let newHeight : CGFloat = titleLabel.frame.size.height
        titleLabel.frame = CGRect.init(x: 15, y: 60 + 50 - 2, width: updateInfoViewWidth - 30, height: newHeight)
        
    }
    
    func changeSubTitle(subTitle : String) {
        let attr = NSMutableAttributedString.init(string: subTitle)
        
        let Font_12 = [NSFontAttributeName : UIFont.systemFont(ofSize: 10)]
        let Color_gray = [NSForegroundColorAttributeName : ColorMethodho(hexValue: 0xb2b2b2)]
        attr .addAttributes(Font_12, range: NSRange.init(location: 0, length: subTitle.characters.count))
        attr .addAttributes(Color_gray, range: NSRange.init(location: 0, length: subTitle.characters.count))
        
        let Paragraph = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        Paragraph.alignment = NSTextAlignment.center
        Paragraph.paragraphSpacing = 6.0
        let Para = [NSParagraphStyleAttributeName : Paragraph];
        attr .addAttributes(Para, range: NSRange.init(location: 0, length: subTitle.characters.count))
        
        subTitleLabel.attributedText = attr
        
        subTitleLabel.sizeToFit()
        let newHeight : CGFloat = subTitleLabel.frame.size.height
        subTitleLabel.frame = CGRect.init(x: 15, y: 175 + 25 - 1.0, width: updateInfoViewWidth - 30, height: newHeight)
        
    }
    
    func removeUpdateView() {
        delegate.clickEventWithType(btType: 2)
        updateBgWin .isHidden = true
    }
    
    func jumpToAppStore(){
        
        let APPStoreURL = URL.init(string: "itms-apps://itunes.apple.com/app/id1099174257")
        
        if updateStatus == false {
            delegate.clickEventWithType(btType: 0)
        }else{
            delegate.clickEventWithType(btType: 1)
            updateBgWin .isHidden = true
        }
        
        UIApplication.shared.openURL(APPStoreURL!)
        
    }
}
