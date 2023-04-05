//
//  blurImage.swift
//  HW
//
//  Created by Leo Lui on 2023/4/4.
//

import Foundation
import UIKit

func blurImage(inputImage:UIImageView) {
    inputImage.contentMode = .scaleToFill
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = inputImage.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    inputImage.alpha = 0.5
    inputImage.addSubview(blurView)
    
}
