//
//  SKRSharedInfo.swift
//  Pods
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit

public class SKRSharedInfo: NSObject {

    public var bundleId: String
    
    public var groupId: String {
        return "group." + self.bundleId
    }
    
    /// 写入视频的目录。注意，直接使用 asset writer 写入 shared group 中会报错的！
    public var videoWriteDir: String = "SKReplaykitVideos"
    
    public init(bundleId: String) {
        self.bundleId = bundleId
    }
    
    public func sharedGroupPath() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.groupId)
    }
    
    public func videoWriteUrl() -> URL? {
        return self.sharedGroupPath()?.appendingPathComponent(self.videoWriteDir)
    }
}
