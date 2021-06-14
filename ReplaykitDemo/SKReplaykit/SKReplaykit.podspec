Pod::Spec.new do |spec|
    spec.name         = 'SKReplaykit'
    spec.version      = "1.0"
    spec.homepage     = "https://www.uiimage.com"
    spec.license      = { :type => 'BSD' }
    spec.author       = { 'kim' => '18666269733@163.com' }
    spec.summary      = '一个 Replaykit 的工具，仅使用 iOS12 以上的 api'
    spec.source       = { :http => 'https://www.uiimage.com' }
    spec.platform     = :ios, '12.0'
    spec.ios.deployment_target = '12.0'
    
    spec.subspec 'shared' do |sp|
        sp.source_files = 'shared/**'
    end

    spec.subspec 'main' do |sp|
        sp.source_files = 'main/**'
    end

    spec.subspec 'extension' do |sp|
        sp.source_files = 'extension/**'
    end
end
