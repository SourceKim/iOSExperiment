//
//  SKRMainProcessor.swift
//  SKReplaykit-main-shared
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit
import ReplayKit

public class SKRMainProcessor: NSObject {
    
    public var extname: String?
    public var info: SKRSharedInfo
    public var needMicrophone = false
    
    public init(info: SKRSharedInfo) {
        self.info = info
    }
    
    public func startButton() -> UIView {
        let rpView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rpView.preferredExtension = self.preferredExtension()
        rpView.showsMicrophoneButton = self.needMicrophone
        return rpView
    }
    
    private func preferredExtension() -> String? {
        if let name = extname {
            return info.bundleId + "." + name
        }
        return nil
    }

}
