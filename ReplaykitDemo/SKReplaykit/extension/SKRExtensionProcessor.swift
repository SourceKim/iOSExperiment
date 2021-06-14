//
//  SKRExtensionProcessor.swift
//  SKReplaykit-main-shared
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit
import ReplayKit

public enum SKRExtensionProcessorType {
    case writeFile
}

public class SKRExtensionProcessor: NSObject {
    
    var handler: SKROutputHandler
    var info: SKRSharedInfo
    
    public init(type: SKRExtensionProcessorType, info: SKRSharedInfo) {
        
        self.info = info
        
        switch type {
        case .writeFile:
            guard let url = info.videoWriteUrl() else {
                fatalError("Can't find url for group: \(info.groupId)")
            }
            self.handler = SKRWriteFileHandler(url: url)
        }
        
        self.handler.setup()
    }
    
    public func onStart() {
    }
    
    public func onOutputSampleBuffer(buffer: CMSampleBuffer, type: RPSampleBufferType) {
        self.handler.onOutputBuffer(buffer: buffer, type: type)
    }
    
    public func onFinished() {
        self.handler.onRecordFinish()
    }

}
