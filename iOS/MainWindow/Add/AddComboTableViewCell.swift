//
//  AddComboTableViewCell.swift
//  NetNewsWire
//
//  Created by Maurice Parker on 11/16/19.
//  Copyright © 2019 Ranchero Software. All rights reserved.
//

import UIKit

final class AddComboTableViewCell: VibrantTableViewCell {

	@IBOutlet weak var icon: UIImageView!
	@IBOutlet weak var label: UILabel!

	override func updateVibrancy(animated: Bool) {
		super.updateVibrancy(animated: animated)

		let iconTintColor = isHighlighted || isSelected ? AppColor.vibrantText : AppColor.secondaryAccent
		if animated {
			UIView.animate(withDuration: Self.duration) {
				self.icon.tintColor = iconTintColor
			}
		} else {
			self.icon.tintColor = iconTintColor
		}
		updateLabelVibrancy(label, color: labelColor, animated: animated)
	}

}
