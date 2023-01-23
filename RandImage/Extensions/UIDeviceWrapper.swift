//
//  UIDeviceWrapper.swift
//  RandImage
//
//  Created by Denys Rybas on 23.01.2023.
//

import UIKit
//import AVFoundation

extension UIDevice {
    func playHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
