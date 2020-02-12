//
//  KSYAudioCtrlView.swift
//  KSYLiveDemo_Swift
//
//  Created by iVermisseDich on 17/1/10.
//  Copyright © 2017年 com.ksyun. All rights reserved.
//

import UIKit

/**
 音频控制相关
 
 主要增加的功能如下:
 1. 混音
 2. 输入音频设备选择
 3. 混响类型选择
 4. 耳返
 */

class KSYAudioCtrlView: KSYUIView {

    var micVol: KSYNameSlider?          /// 混音时, 麦克风的比例
    var bgmVol: KSYNameSlider?          /// 混音时, 背景音乐的比例
    var bgmMix: UISwitch?               /// 混音时, 背景音乐是否混入
    
    var swAudioOnly: UISwitch?          /// 纯音频推流开关 ( 纯音频 == 关闭视频 )
    var muteStream: UISwitch?           /// 静音推流开关 ( 发送音量为0的音频数据 )
    
    var micInput: UISegmentedControl?   /// 音频输入设备选择(话筒, 有限耳麦 或 蓝牙耳麦)
    
    var reverbType: UISegmentedControl? /// 混响类型选择
    var swPlayCapture: UISwitch?        /// 耳返 (本地直接播放采集到的声音) (请戴耳机之后再使用本功能)
    var playCapVol: KSYNameSlider?      /// 本地播放的音量
    var _micType: KSYMicType?
    var micType: KSYMicType? {
        get{
            return getMicType()
        }
        set{
            _micType = newValue
            self.micInput?.selectedSegmentIndex = Int(newValue?.rawValue ?? 0)
        }
    }
    
    func getMicType() -> KSYMicType {
        return KSYMicType.init(rawValue: UInt(micInput!.selectedSegmentIndex))!
    }
    
    private
    var lblPlayCapture: UILabel?
    var lblAudioOnly: UILabel?
    var lblMuteSt: UILabel?
    var lblReverb: UILabel?
    
    override init(withParent pView: KSYUIView) {
        super.init(withParent: pView)
        micVol = addSlider (name: "Microphone Volume", from: 0.0, to: 2.0, initV: 0.9)
        bgmVol = addSlider (name: "background music volume", from: 0.0, to: 2.0, initV: 0.5)
        bgmMix = addSwitch (on: true)
        
        micInput = addSegCtrlWithItems (items: ["Built-in mic", "Headset", "Bluetooth mic"])
        initMicInput ()
        
        lblAudioOnly = addLabel (title: "Pure Audio Streaming") // close the video
        swAudioOnly = addSwitch (on: false) // close the video
        lblMuteSt = addLabel (title: "Mute Push Stream")
        muteStream = addSwitch (on: false)
        
        lblReverb = addLabel (title: "Reverb")
        reverbType = addSegCtrlWithItems (items: ["Close", "Video Studio","Concert", "KTV", "Small Stage"])
        lblPlayCapture = addLabel (title: "ear return")
        swPlayCapture = addSwitch (on: false)
        playCapVol = addSlider (name: "ear volume", from: 0.0, to: 1.0, initV: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutUI() {
        super.layoutUI()
        btnH = 30
        
        putRow1(subV: micVol!)
        putSlider(sl: bgmVol!, andSwitch: bgmMix!)
        putRow1(subV: micInput!)
        putRow(subV: [lblAudioOnly!, swAudioOnly!, lblMuteSt!, muteStream!])
        putLabel(lbl: lblReverb!, andView: reverbType!)
        
        // tip: Array cannot contains NSNull
        let arr: NSArray = NSArray.init(objects: NSNull(), NSNull(), lblPlayCapture!, swPlayCapture!)
        putRow(subV2: arr)
        putRow1(subV: playCapVol)
    }
    
    /// 初始化mic选择控件
    func initMicInput() {
        let bHS = KSYAVAudioSession.isHeadsetInputAvaible()
        let bBT = KSYAVAudioSession.isBluetoothInputAvaible()
        
        micInput?.setEnabled(true, forSegmentAt: 1)
        micInput?.setEnabled(true, forSegmentAt: 2)
        
        if !bHS {
            micInput?.setEnabled(false, forSegmentAt: 1)
        }
        if !bBT {
            micInput?.setEnabled(false, forSegmentAt: 2)
        }
    }
    
}
