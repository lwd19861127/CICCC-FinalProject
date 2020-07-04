//
//  Recommends.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-07-04.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import Foundation

struct Recommends {
    var recommendList: [Recommend]
    
    init(recommendList: [Recommend] = []) {
        self.recommendList = recommendList
    }
}
