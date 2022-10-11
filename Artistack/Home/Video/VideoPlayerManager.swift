//
//  VideoPlayerManager.swift
//  Practice_Artistack
//
//  Created by csh on 2022/07/28.
//

import Foundation
import AVFoundation

class VideoPlayerManager {
    
    typealias completion = () -> Void
    
    private(set) var playerLooper: AVPlayerLooper!
    private(set) var queuePlayer: AVQueuePlayer!
    var playerItem: AVPlayerItem!
    
    var queuePlayers = [AVQueuePlayer]()
    private(set) var isPlaying = false
    
    // TODO: Redesign this method to fit firebase call
    func setupVideo() {
        //Video
        print("You are calling VideoPlayerManager.setupVideo()")
        guard let videoURL = Bundle.main.path(forResource: "dummyVideo", ofType: "mp4") else { // 체크 필요
            debugPrint("dummyVideo.mp4 not found")
            return
        }
        
        let asset: AVAsset = AVAsset(url: URL(fileURLWithPath: videoURL))
        playerItem = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        // Create a new player looper with the queue player and template item
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
    }
    
    // Play the video from the beginning
    func replay(){
        if !isPlaying {
            self.queuePlayer.seek(to: .zero)
            play(completion: nil)
        }
    }
    
    // Play the video from it stops (Or play it from the beginning if the video is not started yet)
    func play(completion: completion?) {
        if !isPlaying {
            self.queuePlayer.play()
            isPlaying = true
            if let completion = completion {
                completion()
            }
        }
    }
    
    // Pause videos
    func pause(completion: completion?){
        if isPlaying {
            self.queuePlayer.pause()
            isPlaying = false
            if let completion = completion {
                completion()
            }
        }
    }
    
    
}




