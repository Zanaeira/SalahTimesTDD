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
		RemoteLoader(client: makeHTTPClient(withRequestCachePolicy: .reloadRevalidatingCacheData), mapper: SalahTimesMapper.map)
	}

	private static func fallbackLoader() -> TimesLoader {
		RemoteLoader(client: makeHTTPClient(withRequestCachePolicy: .returnCacheDataElseLoad), mapper: SalahTimesMapper.map)
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
