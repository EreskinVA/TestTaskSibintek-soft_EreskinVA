//
//  Events.swift
//  TestTaskSibintek-soft_EreskinVA
//
//  Created by Vladimir Ereskin on 06/03/2019.
//  Copyright © 2019 Vladimir Ereskin. All rights reserved.
//

import Foundation

struct Events: Codable {
    let id: Int
    let guid: String
    let name: String
    let beginDate: String
    let endDate: String
    let kind: Int
    let description: String?
    let imageId: Int?
    let venue: String
    let participant: [Participant]
    var favorite: Bool?
    var dateStart: String?
    var timeStart: String?
    var timeEnd: String?
}

struct Participant: Codable {
    let surname: String?
    let name: String?
    let patronyc: String?
    let position: String?
    let company: String?
    let imageId: Int?
}
