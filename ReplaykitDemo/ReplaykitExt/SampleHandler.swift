//
//  SampleHandler.swift
//  ReplaykitExt
//
//  Created by 苏金劲 on 2021/6/14.
//

import ReplayKit
import SKReplaykit

class SampleHandler: RPBroadcastSampleHandler {
    
    let processor = SKRExtensionProcessor(type: .writeFile, info: SKRSharedInfo(bundleId: "com.kedc.ReplaykitDemo"))

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
//        print("broadcastStarted")
        self.processor.onStart()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        
        self.processor.onFinished()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        
        self.processor.onOutputSampleBuffer(buffer: sampleBuffer, type: sampleBufferType)
    }
}
