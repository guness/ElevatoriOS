//
//  SoundManager.swift
//  Elevator
//
//  Created by Sinan Güneş on 6.08.2018.
//  Copyright © 2018 Sinan Güneş. All rights reserved.
//

import Foundation
import AVFoundation


class SoundManager{
    var player: AVAudioPlayer?
    
    static let sharedInstance: SoundManager = {
        let instance = SoundManager()
        // setup code
        return instance
    }()
    
    func playDing() {
        guard let url = Bundle.main.url(forResource: "elevator_ding", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

