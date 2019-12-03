//
//  URL+ExprByString.swift
//  NEUGELBTask
//
//  Created by Hussien Gamal Mohammed on 12/3/19.
//  Copyright © 2019 NEUGELB. All rights reserved.
//

import Foundation
extension URL: ExpressibleByStringLiteral, ExpressibleByStringInterpolation {
    public init(extendedGraphemeClusterLiteral value: String) {
        self = URL(string: value)!
    }

    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
