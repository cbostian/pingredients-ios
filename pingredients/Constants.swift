//
//  Constants.swift
//  pingredients
//
//  Created by Catherine Bostian on 2/13/18.
//  Copyright © 2018 Catherine Bostian. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static var columns: Int {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            return 3
        } else if UIDevice.current.userInterfaceIdiom == .pad && UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            return 4
        } else {
            return 2
        }
    }
    static let cellPadding: CGFloat = 5.0
    
    static var captionFont: UIFont {
        let captionFontStyle = UIFontTextStyle.body
        return UIFontMetrics(forTextStyle: captionFontStyle).scaledFont(for: UIFont.preferredFont(forTextStyle: captionFontStyle))
    }
}
