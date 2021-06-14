//
//  SKRWriteFileHandler.swift
//  SKReplaykit-extension-shared
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit
import ReplayKit
import AVFoundation

class SKRWriteFileHandler: SKROutputHandler {
    
    var writer: AVAssetWriter?
    var videoInput: AVAssetWriterInput?
    var audioInput: AVAssetWriterInput?
    
    var url: URL
    var filepath: URL
    
    init(url: URL) {
        self.url = url
        
        // 默认创建一下这个目录
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Can't create url: \(url), error: \(error)")
        }
        
        // 使用 [timestamp].mp4 作为文件名
        let filename = "\(Int(NSDate().timeIntervalSince1970 * 1000)).mp4"
        self.filepath = url.appendingPathComponent(filename)
    }
    
    private func configureVideoInput() {
        let size = UIScreen.main.bounds.size
        let pixelCnt = size.width * size.height
        let bitsPerPixel: CGFloat = 7.5
        let bitsPerSec = pixelCnt * bitsPerPixel
        
        let compressProperties = [
            AVVideoAverageBitRateKey: bitsPerSec,
            AVVideoExpectedSourceFrameRateKey: 25,
            AVVideoMaxKeyFrameIntervalKey: 15,
            AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel,
            AVVideoPixelAspectRatioKey:[
                AVVideoPixelAspectRatioHorizontalSpacingKey: 1,
                AVVideoPixelAspectRatioVerticalSpacingKey: 1
            ]
        ] as [String : Any]
        
        let scale = UIScreen.main.scale
        
        let outputSettings = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
            AVVideoWidthKey: size.width * scale,
            AVVideoHeightKey: size.height * scale,
            AVVideoCompressionPropertiesKey: compressProperties
        ] as [String : Any]
        
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        input.expectsMediaDataInRealTime = true
        
        self.videoInput = input
    }
    
    private func configureAudioInput() {
        let outputSettings = [
            AVEncoderBitRatePerChannelKey: 28000,
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 22050
        ]
        
        let input = AVAssetWriterInput(mediaType: .audio, outputSettings: outputSettings)
        self.audioInput = input
    }
    
    @discardableResult
    private func handleVideoBuffer(buffer: CMSampleBuffer) -> Bool {
        guard let input = self.videoInput else { return false }
        
        guard input.isReadyForMoreMediaData else {
            return false
        }
        
        guard input.append(buffer) else {
            return false
        }
        
        return true
        
    }
    
    private func handleAudioBuffer(buffer: CMSampleBuffer) {
        
    }
    
    override func setup() {
        self.configureVideoInput()
        self.configureAudioInput()
        guard let videoInput = self.videoInput,
              let audioInput = self.audioInput else {
            fatalError("No video or audio input provide.")
        }
        do {
            let writer = try AVAssetWriter(outputURL: self.filepath, fileType: .mp4)
            if writer.canAdd(videoInput) {
                writer.add(videoInput)
            } else {
                fatalError("Can't add Video input.")
            }
            if writer.canAdd(audioInput) {
                writer.add(audioInput)
            } else {
                fatalError("Can't add Audio input.")
            }
            self.writer = writer
        } catch {
            fatalError("Can't create writer with err: \(error), url: \(self.url)")
        }
    }
    
    override func onOutputBuffer(buffer: CMSampleBuffer, type: RPSampleBufferType) {
        
        print("On output buffer, type: \(type.rawValue)")
        
        func handleBuffer() {
            switch type {
            case .video:
                self.handleVideoBuffer(buffer: buffer)
                break
            case .audioMic:
                self.handleAudioBuffer(buffer: buffer)
                break
            case .audioApp:
                self.handleAudioBuffer(buffer: buffer)
                break
            @unknown default:
                fatalError("On unknown type buffer output: \(type.rawValue)")
            }
        }
        
        guard let writer = self.writer else { return }
        print("status: \(writer.status.rawValue)")
        switch writer.status {
        case .cancelled, .failed, .completed:
            print("status error, status: \(String(describing: writer.error))")
            return
        case .unknown:
            if type != .video {
                return
            }
            let res = writer.startWriting()
            if !res {
                self.onRecordFinish()
            }
            let duration = CMSampleBufferGetPresentationTimeStamp(buffer)
            writer.startSession(atSourceTime: duration)
            break
        case .writing:
            handleBuffer()
            break
        @unknown default:
            fatalError("Unknow asset writer status: \(writer.status)")
        }
        

    }
    
    override func onRecordFinish() {
        print("Record did finished")
        if let status = self.writer?.status, status == .writing {
            self.audioInput?.markAsFinished()
            self.videoInput?.markAsFinished()
            self.writer?.finishWriting(completionHandler: {
                print("Write finished")
            })
        } else {
            print("On record finished, but writer status is wrong: \(String(describing: writer?.status.rawValue))")
        }

    }

}
