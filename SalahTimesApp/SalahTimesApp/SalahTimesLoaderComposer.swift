//
//  SalahTimesLoaderComposer.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation
import SalahTimes

final class SalahTimesLoaderComposer {

	let loader: TimesLoader

	init() {
		loader = SalahTimesLoaderWithFallbackComposite(primaryLoader: Self.primaryLoader(), fallbackLoader: Self.fallbackLoader())
	}

	private static func primaryLoader() -> TimesLoader {
		SalahTimesLoader(client: makeHTTPClient(withRequestCachePolicy: .reloadRevalidatingCacheData))
	}

	private static func fallbackLoader() -> TimesLoader {
		SalahTimesLoader(client: makeHTTPClient(withRequestCachePolicy: .returnCacheDataElseLoad))
	}

	private static func makeHTTPClient(withRequestCachePolicy policy: NSURLRequest.CachePolicy) -> HTTPClient {
		let config = URLSessionConfiguration.default
		config.urlCache = makeCache()
		config.requestCachePolicy = policy

		let session = URLSession(configuration: config)

		return URLSessionHTTPClient(session: session)
	}

	private static func makeCache() -> URLCache {
		let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
		let diskCacheURL = cachesURL.appendingPathComponent("DownloadCache")

		return URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, directory: diskCacheURL)
	}

}

extension RemoteLoader: @retroactive TimesLoader where Resource == SalahTimes {}
