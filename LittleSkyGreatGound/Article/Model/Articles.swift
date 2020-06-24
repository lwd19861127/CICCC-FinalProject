//
//  Articles.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-23.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import Foundation

struct Articles {
    var articleList: [Article]
    
    init(articleList: [Article] = []) {
        self.articleList = articleList
    }
}
