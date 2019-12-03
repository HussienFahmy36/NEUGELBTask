//
//  NUMoviesDBDataWorker.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/1/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
enum NUWorkerEndPoints: String {
    case NowPlaying = "/movie/now_playing"
    case SearchMovies = "/search/movie"
}

typealias NUWorkerResponse = (NUMoviesResponse?, _ error: NUErrorMessages?) -> ()
class NUMoviesDBDataWorker {
    let baseURLV3 = NUStringsConstants.imdbAPIBaseURL
    var token = NUStringsConstants.apiToken
    let networkLayer = NetworkLayer()
    let codableParser = CodableJsonParser()

    func getNowPlaying(page: Int, completion: @escaping NUWorkerResponse) {
        guard let url = buildURL(with: .NowPlaying, page: page) else {
            return
        }
        networkLayer.downloadAsync(from: url) {[weak self] (data, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                completion(nil, error)
                return
            }
            let result = self.codableParser.parse(data: data,
                                                  to: NUMoviesResponse.self)
            completion(result, nil)
            return

        }
    }

    func searchMovie(keyword: String, completion: @escaping NUWorkerResponse) {
        guard let url = buildURL(with: .SearchMovies, searchKeyword: keyword) else {
            return
        }
        networkLayer.downloadAsync(from: url) {[weak self] (data, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                completion(nil, error)
                return
            }
            let result = self.codableParser.parse(data: data,
                                                  to: NUMoviesResponse.self)
            completion(result, nil)
            return

        }
    }

    private func buildURL(with endPoint: NUWorkerEndPoints, page: Int? = nil, searchKeyword: String? = nil) -> URL? {
        let tokenParam = "?api_key=" + token
        var urlString = baseURLV3 + endPoint.rawValue + tokenParam
        if let page = page {
            let pageParam =  "&page=" + "\(page)"
            urlString += pageParam
        }
        if let searchKeyword = searchKeyword {
            let searchKeywordWithPercent = searchKeyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let keywordParam =  "&query=" + "\(searchKeywordWithPercent ?? "")"
            urlString += keywordParam
        }
        return "\(urlString)"
    }
}

