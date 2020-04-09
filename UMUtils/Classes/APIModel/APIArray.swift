//
//  APIArray.swift
//  mercadoon
//
//  Created by brennobemoura on 15/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation

open class APIArray<Element: Decodable>: Decodable {
    public let data: [Element]
    public let meta: MetaPage?

    public init(data: [Element], meta metaPage: MetaPage? = nil) {
        self.data = data
        self.meta = metaPage
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.data = try container.decode(.data)
        self.meta = try? container.decode(.meta)
    }
}

public extension APIArray {
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
}
