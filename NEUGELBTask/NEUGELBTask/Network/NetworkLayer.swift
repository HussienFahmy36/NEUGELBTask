//
//  NetworkLayer.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 30/11/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
import UIKit

public enum NUErrorMessages: String {
    case parse = "Parse error"
    case runtime = "Runtime error"
    case dataIsNil = "Data is nil"
    case fileSizeExceedsLimit = "file size exceeds limit"
    case cacheIsFull = "cache is full"
    case maxNumberOfFilesReached = "cached files number exceeds limit"
    case urlNotFound = "Url not found"
    case urlInvalid = "Url is invalid"
    case noResponse = "No response from server"
}

class NetworkLayer {

    private var session = URLSession.init(configuration: .default)
    private var task: URLSessionDataTask?

    init() {
        session.configuration.timeoutIntervalForRequest = 10
        session.configuration.timeoutIntervalForResource = 10
    }

    public func downloadAsync(from url: URL, dataReceived: @escaping (Data?, NUErrorMessages?) -> ()) {
    if !isValid(url: url) {
        dataReceived(nil, .urlInvalid)
    }
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    task = session.dataTask(with: url) {[weak self] (data, response, error) in
        guard let self = self else {
            return
        }
        if let httpURLResponse = (response as? HTTPURLResponse) {
        if httpURLResponse.statusCode == 200 {
            guard let receivedData = data else {
                dataReceived(nil, .dataIsNil)
                return
            }
            let receivedDataAsString = receivedData.base64EncodedString()
            let receivedDataAfterConvert = Data(base64Encoded: receivedDataAsString)

            dataReceived(receivedDataAfterConvert, nil)
            return
        }
        else {
            if httpURLResponse.statusCode == 404 {
                dataReceived(nil, .urlNotFound)
                self.task?.suspend()
                return
            } else {
                dataReceived(nil, .dataIsNil)
                self.task?.suspend()
                return
            }
        }
        } else {
            dataReceived(nil, .noResponse)
            self.task?.suspend()
            return
        }
    }
        task?.resume()
    }


    private func isValid(url: URL) -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && url.absoluteString.count > 0) else { return false }
        if detector!.numberOfMatches(in: url.absoluteString, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, url.absoluteString.count)) > 0 {
            return true
        }
        return false
    }
}
