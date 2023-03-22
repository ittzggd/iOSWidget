//
//  apiStruct.swift
//  WidgetTest_API
//
//  Created by Katherine JANG on 3/22/23.
//

import Foundation
import SwiftUI

struct TextModel: Codable {
    enum CodingKeys: String, CodingKey {
        case datas = "data"
    }
    let datas: [String]
}


