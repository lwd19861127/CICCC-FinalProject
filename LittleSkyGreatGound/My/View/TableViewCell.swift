//
//  TableViewCell.swift
//  UITest
//
//  Created by WendaLi on 2020-07-01.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

}
