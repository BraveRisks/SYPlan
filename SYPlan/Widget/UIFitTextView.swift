//
//  UIFitTextView.swift
//  SYPlan
//
//  Created by Ray on 2019/5/21.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit

/// Remove all margin & padding
/// ```
/// Note
/// Don't forget to turn off scrollEnabled in the Inspector!
/// refence：https://stackoverflow.com/questions/746670/how-to-lose-margin-padding-in-uitextview
/// ```
class UIFitTextView: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        fit()
    }

    private func fit() {
        isScrollEnabled = false
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
    }
}
