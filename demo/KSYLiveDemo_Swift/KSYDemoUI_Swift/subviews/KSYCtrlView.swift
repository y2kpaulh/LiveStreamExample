//
//  KSYCtrlView.swift
//  KSYLiveDemo_Swift
//
//  Created by iVermisseDich on 17/1/10.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

import UIKit

class KSYCtrlView: KSYUIView {

    var btnFlash: UIButton?
    var btnCameraToggle: UIButton?
    var btnQuit: UIButton?
    var btnStream: UIButton?
    var btnCapture: UIButton?

    var lblStat: KSYStateLableView?
    var lblNetwork: UILabel?
    
    //Background music
    // Image and beauty related
    // Sound related: Remix / Reverb / Earback, etc.
    // Other functions: such as screenshot
    var menuBtns: [UIButton]?
    //Back to menu page
    var backBtn: UIButton?
    
    private
    var _curSubMenuView: KSYUIView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(menuNames: [String]) {
        super.init()
        btnFlash = addButton (title: "Flash")
        btnCameraToggle = addButton (title: "Front/Rear")
        btnQuit = addButton (title: "Quit")
        lblNetwork = addLabel (title: "")
        btnStream = addButton (title: "Push Stream")
        btnCapture = addButton (title: "Capture")
        lblStat = KSYStateLableView()
        addSubview(lblStat!)
        
        // format
        lblNetwork?.textAlignment = .center
        
        // add menu
        var btnArray = Array<UIButton>()
        for name: String in menuNames {
            btnArray.append(addButton(title: name))
        }
        
        menuBtns = btnArray
        
        backBtn = addButton(title: "Capture", action: #selector(onBack(sender:)))
        backBtn?.isHidden = true
        _curSubMenuView = nil
    }
    
    override func layoutUI() {
        super.layoutUI()
        if width < height {
            yPos = gap * 5  // skip status
        }
        
        putRow(subV: [btnQuit!, btnFlash!, btnCameraToggle!, backBtn!])
        
        putRow(subV: menuBtns!)
        hideMenuBtn(bHide: !backBtn!.isHidden)
        
        yPos -= btnH
        let freeHgt = height - yPos - btnH - gap
        lblStat?.frame = CGRect.init(x: gap, y: yPos, width: winWdt - gap * 2, height: freeHgt)
        yPos += freeHgt
        
        // put at bottom
        putRow3(subV0: btnCapture!, and: lblNetwork!, and: btnStream!)
        
        if let _ = _curSubMenuView {
            _curSubMenuView!.frame = lblStat!.frame
            _curSubMenuView!.layoutUI()
        }
    }
    
    func hideMenuBtn(bHide: Bool) {
        backBtn!.isHidden = !bHide // 返回
        // hide menu
        for btn in menuBtns! {
            btn.isHidden = bHide
        }
    }
    
    @objc func onBack(sender: UIButton) {
        if let _ = _curSubMenuView {
            _curSubMenuView?.isHidden = true
        }
        hideMenuBtn(bHide: false)
    }
    
    func showSubMenuView(view: KSYUIView) {
        _curSubMenuView = view
        hideMenuBtn(bHide: true)
        view.isHidden = false
        view.frame = lblStat!.frame
        view.layoutUI()
    }
}
