//
//  KSYBgmView.swift
//  KSYLiveDemo_Swift
//
//  Created by iVermisseDich on 17/1/10.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

import UIKit

class KSYBgmView: KSYUIView {

    var previousBtn: UIButton?
    var playBtn: UIButton?
    var pauseBtn: UIButton?
    var stopBtn: UIButton?
    var progressV: UIProgressView?
    var volumSl: KSYNameSlider?
    var nextBtn: UIButton?
    var muteBtn: UIButton?
    var loopType: UISegmentedControl?
    
    var bgmPath: String?        /// 当前播放的背景音乐的路径
    var _bgmStatus: String?
    var bgmStatus: String?{      /// bgmStatus string
        get{
            return _bgmStatus
        }
        set{
            _bgmStatus = newValue
            _bgmTitle?.text = bgmStatus?.appending(_bgmSel?.fileInfo ?? "")
        }
    }
    var bgmPattern: [String]?/// match pattern
    
    private
    var _bgmTitle: UILabel?
    var _bgmSel: KSYFileSelector?
    var _cnt: Int?
    
    override init(withParent pView: KSYUIView) {
        super.init(withParent: pView)
        _bgmTitle = addLabel (title: "BGM path Documents/bgms")
        progressV = UIProgressView ()
        addSubview (progressV!)
        previousBtn = addButton (title: "Previous")
        playBtn = addButton (title: "play")
        pauseBtn = addButton (title: "Pause")
        stopBtn = addButton (title: "Stop")
        volumSl = addSlider (name: "volume", from: 0, to: 100, initV: 50)
        volumSl? .slider.value = 50
        nextBtn = addButton (title: "Next")
        _bgmStatus = "idle"
        bgmPattern = [".mp3", ".m4a", ".aac"]
        _bgmSel = KSYFileSelector.init (dir: "/Documents/bgms/",suf: bgmPattern!)
        bgmPath = _bgmSel? .filePath
        _cnt = _bgmSel! .fileList! .count
        loopType = addSegCtrlWithItems (items: ["Single Play", "Single Loop", "Random Play", "Loop Play"])
        
        loopType?.selectedSegmentIndex = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutUI() {
        super.layoutUI()
        btnH = 10
        putRow1(subV: progressV!)
        btnH = 30
        putRow1(subV: _bgmTitle!)
        putRow(subV: [previousBtn!, playBtn!, pauseBtn!, stopBtn!, nextBtn!])
        putRow1(subV: volumSl!)
        putRow1(subV: loopType!)
    }
    
    // get next bgm path to play
    func loopNextBgmPath() -> String {
    // "Single track play", "Single track loop", "Shuffle play", "Loop play"
        switch loopType!.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            _ = _bgmSel!.selectFileWithType(type: .RANDOM)
            break
        case 3:
            _ = _bgmSel!.selectFileWithType(type: .NEXT)
            break
        default:
            ()
        }
        
        return updateBgmPath()
    }
    
    /// get next bgm path to play
    func nextBgmPath() -> String {
        _ = _bgmSel?.selectFileWithType(type: .NEXT)
        return updateBgmPath()
    }
    
    func previousBgmPath() -> String {
        _ = _bgmSel?.selectFileWithType(type: .PREVIOUS)
        return updateBgmPath()
    }

    func updateBgmPath() -> String {
        _bgmTitle?.text = bgmStatus?.appending(_bgmSel!.fileInfo)
        bgmPath = _bgmSel?.filePath
        return _bgmSel!.filePath
    }
    
}
