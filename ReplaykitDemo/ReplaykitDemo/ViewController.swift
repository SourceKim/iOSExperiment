//
//  ViewController.swift
//  ReplaykitDemo
//
//  Created by 苏金劲 on 2021/6/14.
//

import UIKit
import SKReplaykit
import AVKit

class ViewController: UIViewController {
    
    var processor: SKRMainProcessor?
    
    let info = SKRSharedInfo(bundleId: "com.kedc.ReplaykitDemo")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.processor = SKRMainProcessor(info: info)
        self.processor?.extname = "ReplaykitExt"
        self.processor?.needMicrophone = true
        
        guard let btn = self.processor?.startButton() else {
            fatalError("Cant create replay kit start button!")
        }
        
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.center = self.view.center
        self.view.addSubview(btn)
        

        let playBtn = UIButton(type: .system)
        playBtn.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        playBtn.center.x = btn.center.x
        playBtn.center.y = btn.center.y + 100
        
        playBtn.setTitle("播放第一个视频", for: .normal)
        playBtn.addTarget(self, action: #selector(onPlayClicked), for: .touchUpInside)
        self.view.addSubview(playBtn)
    }
    
    @objc func onPlayClicked() {
        if let dir = info.videoWriteUrl(),
           var res = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []) {
            print(res)
            // 稍微排序一下，保证每次都播放最新录制的一个视频
            res.sort { (url1, url2) -> Bool in
                return url1.path > url2.path
            }
            // 取第一个，也就是最新的那个视频
            if let firstRes = res.first {
                let player = AVPlayerViewController()
                player.player = AVPlayer(url: firstRes)
                self.present(player, animated: true) {
                    player.player?.play()
                    if let err = player.player?.error {
                        print("Play error: \(err)")
                    }
                }
            }
        } else {
            print("No dir: \(String(describing: info.videoWriteUrl))")
        }
    }


}

