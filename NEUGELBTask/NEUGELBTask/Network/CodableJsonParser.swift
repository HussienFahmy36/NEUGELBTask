//
//  CodableJsonParser.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 30/11/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
public class CodableJsonParser {
    public func parse<T: Codable>(data: Data?, to target: T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let dataToParse = data else {
            return nil
        }
        do {
            let decodedData = try decoder.decode(T.self, from: dataToParse)
            return decodedData
        } catch let error {
            print(error)
        }
        return nil
    }
    public init() {

    }
}
