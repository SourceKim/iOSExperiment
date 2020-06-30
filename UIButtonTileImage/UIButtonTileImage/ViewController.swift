////  ViewController.swift
//  UIButtonTileImage
//
//  Created by Su Jinjin on 2020/6/30.
//  Copyright © 2020 苏金劲. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let btn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.frame.size = CGSize(width: 300, height: 300)
        btn.center = self.view.center
        self.view.addSubview(btn)
        
        btn.setImage(#imageLiteral(resourceName: "avatar"), for: .normal)
        
//        self.tileButtonImage_0()
//        self.tileButtonImage_1()
    }
    
    /* 拉伸方式 0 - 直接修改 UIButton 的拉伸
     
     通过设置 UIButton 的
     `contentHorizontalAlignment` & `contentVerticalAlignment`
     两个属性为 `.fill`
     */
    private func tileButtonImage_0() {
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
    }
    
    /* 拉伸方式 1 - 通过可变形的（Resizable） UIImage 拉伸
     
     通过 `resizableImage` 获取一个模式为 `.stretch` 的可变型 UIImage
     然后设置为 UIButton 的 backgroundImage
     */
    private func tileButtonImage_1() {
        
        var image = btn.image(for: .normal)
        image = image?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        
        btn.setImage(nil, for: .normal)
        btn.setBackgroundImage(image, for: .normal)
    }

}

