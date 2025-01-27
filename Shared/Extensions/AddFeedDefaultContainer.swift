//
//  AddFeedDefaultContainer.swift
//  NetNewsWire-iOS
//
//  Created by Maurice Parker on 11/16/19.
//  Copyright © 2019 Ranchero Software. All rights reserved.
//

import Foundation
import Account

struct AddFeedDefaultContainer {

	static var defaultContainer: Container? {

		if let accountID = AppDefaults.addFeedAccountID, let account = AccountManager.shared.activeAccounts.first(where: { $0.accountID == accountID }) {
			if let folderName = AppDefaults.addFeedFolderName, let folder = account.existingFolder(withDisplayName: folderName) {
				return folder
			} else {
				return substituteContainerIfNeeded(account: account)
			}
		} else if let account = AccountManager.shared.sortedActiveAccounts.first {
			return substituteContainerIfNeeded(account: account)
		} else {
			return nil
		}

	}

	static func saveDefaultContainer(_ container: Container) {
		AppDefaults.addFeedAccountID = container.account?.accountID
		if let folder = container as? Folder {
			AppDefaults.addFeedFolderName = folder.nameForDisplay
		} else {
			AppDefaults.addFeedFolderName = nil
		}
	}

	private static func substituteContainerIfNeeded(account: Account) -> Container? {
		if !account.behaviors.contains(.disallowFeedInRootFolder) {
			return account
		} else {
			if let folder = account.sortedFolders?.first {
				return folder
			} else {
				return nil
			}
		}
	}

}
