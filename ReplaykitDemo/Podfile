workspace 'ReplaykitDemo.xcworkspace'
platform :ios, '12.0'

# 主 APP
target 'ReplaykitDemo' do
    project 'ReplaykitDemo.xcodeproj'
    pod 'SKReplaykit/shared', :path => './SKReplaykit/SKReplaykit.podspec'
    pod 'SKReplaykit/main', :path => './SKReplaykit/SKReplaykit.podspec'
end

# Replaykit 的 Extension
target 'ReplaykitExt' do
    project 'ReplaykitDemo.xcodeproj'
    pod 'SKReplaykit/shared', :path => './SKReplaykit/SKReplaykit.podspec'
    pod 'SKReplaykit/extension', :path => './SKReplaykit/SKReplaykit.podspec'
end
