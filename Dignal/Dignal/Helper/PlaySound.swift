//
//  PlaySound.swift
//  MulMulMarket
//
//  Created by 정정욱 on 6/25/24.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

// sound: 재생할 오디오 파일의 이름을 나타내는 문자열. type: 오디오 파일의 확장자를 나타내는 문자열(예: "mp3", "wav").
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("error: could not find and play the sound file...")
        }
    }
}
