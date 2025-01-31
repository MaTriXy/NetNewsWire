//
//  UnreadFeed.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 11/19/17.
//  Copyright © 2017 Ranchero Software. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import Foundation
#endif
import RSCore
import Account
import Articles
import ArticlesDatabase

// This just shows the global unread count, which appDelegate already has. Easy.

final class UnreadFeed: PseudoFeed {

	var account: Account?

	public var defaultReadFilterType: ReadFilterType {
		return .alwaysRead
	}

	var sidebarItemID: SidebarItemIdentifier? {
		return SidebarItemIdentifier.smartFeed(String(describing: UnreadFeed.self))
	}

	let nameForDisplay = NSLocalizedString("All Unread", comment: "All Unread pseudo-feed title")
	let fetchType = FetchType.unread(nil)

	var unreadCount = 0 {
		didSet {
			if unreadCount != oldValue {
				postUnreadCountDidChangeNotification()
			}
		}
	}

	var smallIcon: IconImage? {
		return AppImage.unreadFeed
	}

	#if os(macOS)
	var pasteboardWriter: NSPasteboardWriting {
		return SmartFeedPasteboardWriter(smartFeed: self)
	}
	#endif

	init() {

		self.unreadCount = AccountManager.shared.unreadCount
		NotificationCenter.default.addObserver(self, selector: #selector(unreadCountDidChange(_:)), name: .UnreadCountDidChange, object: AccountManager.shared)
	}

	@objc func unreadCountDidChange(_ note: Notification) {

		assert(note.object is AccountManager)
		unreadCount = AccountManager.shared.unreadCount
	}
}

extension UnreadFeed: ArticleFetcher {

	func fetchArticles() throws -> Set<Article> {
		return try fetchUnreadArticles()
	}

	func fetchArticlesAsync(_ completion: @escaping ArticleSetResultBlock) {
		fetchUnreadArticlesAsync(completion)
	}

	func fetchUnreadArticles() throws -> Set<Article> {
		return try AccountManager.shared.fetchArticles(fetchType)
	}

	func fetchUnreadArticlesAsync(_ completion: @escaping ArticleSetResultBlock) {
		AccountManager.shared.fetchArticlesAsync(fetchType, completion)
	}
}
