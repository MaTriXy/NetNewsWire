//
//  InitialFeedDownloader.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 9/3/16.
//  Copyright © 2016 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import Parser
import RSWeb

struct InitialFeedDownloader {

	static func download(_ url: URL,_ completion: @escaping (_ parsedFeed: ParsedFeed?) -> Void) {

		Downloader.shared.download(url) { (data, response, error) in
			guard let data = data else {
				completion(nil)
				return
			}

			Task.detached {
				let parsedFeed = try? FeedParser.parse(urlString: url.absoluteString, data: data)
				Task { @MainActor in
					completion(parsedFeed)
				}
			}
		}
	}
}
