//
//  LoginViewCell.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-07-02.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class LoginViewCell: UITableViewCell {

    private var hStackView: UIStackView!
    
    var userImage: UIImageView = {
        let iv = UIImageView()
        let userImageHeightAndWidth = 100
        iv.image = .userImage
        iv.frame  = CGRect(x: 0, y: 0, width: userImageHeightAndWidth, height: userImageHeightAndWidth)
        iv.layer.cornerRadius = iv.frame.size.width / 2
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.constraintWidth(equalToConstant: CGFloat(userImageHeightAndWidth), heightEqualToConstant: CGFloat(userImageHeightAndWidth))
        return iv
    }()
    
    var userIDLable:UILabel = {
        let lb = UILabel()
        lb.text = "Hi, there!"
        lb.font = .preferredFont(forTextStyle: .headline)
        lb.textAlignment = .left
        return lb
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hStackView = HorizontalStackView(arrangedSubviews: [userImage, userIDLable], spacing: 20, alignment: .center, distribution: .fill)
        contentView.addSubview(hStackView)
        hStackView.anchors(topAnchor: contentView.topAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, bottomAnchor: contentView.bottomAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0), size: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

}
