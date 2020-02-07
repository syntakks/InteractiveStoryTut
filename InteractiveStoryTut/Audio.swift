//
//  Audio.swift
//  InteractiveStoryTut
//
//  Created by Stephen Wall on 2/7/20.
//  Copyright © 2020 syntaks.io. All rights reserved.
//

import Foundation
import AudioToolbox

extension Story {
    var soundEffectName: String {
        switch self {
        case .droid, .home: return "HappyEnding"
        case .monster: return "Ominous"
        default: return "PageTurn"
        }
    }
    
    var soundEffectURL: URL {
        let path = Bundle.main.path(forResource: soundEffectName, ofType: "wav")!
        return URL(fileURLWithPath: path)
    }
}

class SoundEffectsPlayer {
    var sound: SystemSoundID = 0 // 32bit int for resource address.. could it be!?
    
    func playSound(for story: Story) {
        let soundURL = story.soundEffectURL as CFURL
        AudioServicesCreateSystemSoundID(soundURL, &sound) // This is a pointer. This is getting the resource address and storing it in the sound variable, BYTE representaion of the sound file. Memory Locations.
        AudioServicesPlaySystemSound(sound)
    }
    
}
