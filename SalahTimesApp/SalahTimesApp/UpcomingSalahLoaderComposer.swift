//
//  UpcomingSalahLoaderComposer.swift
//  SalahTimesApp
//
//  Created by Suhayl Ahmed on 03/05/2025.
//

import Foundation
import SalahTimes

final class UpcomingSalahLoaderComposer {

	let loader: UpcomingSalahLoader

	init() {
		loader = UpcomingSalahLoaderWithFallbackComposite(primaryLoader: Self.primaryLoader(), fallbackLoader: Self.fallbackLoader())
	}

	private static func primaryLoader() -> RemoteLoader<UpcomingSalah> {
		RemoteLoader(client: makeHTTPClient(withRequestCachePolicy: .reloadRevalidatingCacheData), mapper: UpcomingSalahMapper.map)
	}

	private static func fallbackLoader() -> RemoteLoader<UpcomingSalah> {
		RemoteLoader(client: makeHTTPClient(withRequestCachePolicy: .returnCacheDataElseLoad), mapper: UpcomingSalahMapper.map)
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

extension RemoteLoader: @retroactive UpcomingSalahLoader where Resource == UpcomingSalah {}
