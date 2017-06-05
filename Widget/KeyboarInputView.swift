//
//  KeyboarInputView.swift
//  SWCampus
//
//  Created by 11111 on 2017/1/1.
//  Copyright © 2017年 WanHang. All rights reserved.
//

import UIKit

@objc(cameraTapEventDelegate)
protocol cameraTapEventDelegate {
    func cameraTap()
    func topicChangeIconTap()
}

public class KeyboarInputView: UIView {

    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : cameraTapEventDelegate! = nil
    var topicGuideImageView : UIImageView!
    
    func initUI() {
        self.backgroundColor = ColorMethodho(hexValue: 0xfafafa)
        
        let cameraView = UIImageView.init(frame: CGRect.init(x: 20, y: 11.5, width: 21, height: 18))
        cameraView.image = #imageLiteral(resourceName: "cameraInner")
        let camTap = UITapGestureRecognizer.init(target: self, action: #selector(camTapEve))
        cameraView.addGestureRecognizer(camTap)
        self.addSubview(cameraView)
        
        let topicView : UIImageView = UIImageView.init(frame: CGRect.init(x: cameraView.frame.maxX + 20, y: cameraView.frame.minY, width: 21, height: 18))
        topicView.image = #imageLiteral(resourceName: "topicChangeInner")
        let topicTap = UITapGestureRecognizer.init(target: self, action: #selector(topicChange))
        topicView.addGestureRecognizer(topicTap)
        self.addSubview(topicView)
        
        var guideExit : String? = UserDefaults.standard.object(forKey: "exit") as? String
        if guideExit == nil {
            guideExit = "0"
            UserDefaults.standard.set(guideExit, forKey: "exit")
            UserDefaults.standard.synchronize()
        }
        
        if guideExit == "0" {
            topicGuideImageView = UIImageView.init(frame: CGRect.init(x: topicView.frame.maxX + 5, y: topicView.frame.minY - 3.5, width: 200, height: 25))
            topicGuideImageView.image = #imageLiteral(resourceName: "topicGuide")
            let guideTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(guideTapEvent))
            topicGuideImageView.addGestureRecognizer(guideTap)
            
            self.addSubview(topicGuideImageView)
        }
        
        
        
        let seLine_top = CALayer.init()
        seLine_top.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 0.5)
        seLine_top.backgroundColor = ColorMethodho(hexValue: 0xcccccc).cgColor
        self.layer.addSublayer(seLine_top)
        
        let seLine_bottom = CALayer.init()
        seLine_bottom.frame = CGRect.init(x: 0, y: 40.5, width: ScreenWidth, height: 0.5)
        seLine_bottom.backgroundColor = ColorMethodho(hexValue: 0xcccccc).cgColor
//        self.layer.addSublayer(seLine_bottom)
    }
    
    func camTapEve() {
        delegate.cameraTap()
    }
    
    func topicChange() {
        delegate.topicChangeIconTap()
    }

    func guideTapEvent() {
        
        UIView.animate(withDuration: 0.1, animations: { 
            self.topicGuideImageView.alpha = 0
        }) { (true) in
            self.topicGuideImageView.removeFromSuperview()
            UserDefaults.standard.set("1", forKey: "exit")
            UserDefaults.standard.synchronize()
        }
    }
}
