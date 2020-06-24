//
//  ArticleTableViewCell.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-24.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = .darkGray
        detailTextLabel?.textColor = .darkGray
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

}
