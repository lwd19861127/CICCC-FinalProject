//
//  ArticleTableViewCell.swift
//  LittleSkyGreatGound
//
//  Created by WendaLi on 2020-06-24.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    private let thumbnailView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.constraintWidth(equalToConstant: 128, heightEqualToConstant: 128)
      return iv
    }()
    
    private let titleLabel: UILabel = {
      let lb = UILabel()
      lb.font = .preferredFont(forTextStyle: .headline)
      lb.numberOfLines = 0
      lb.translatesAutoresizingMaskIntoConstraints = false
      lb.setContentHuggingPriority(.defaultHigh, for: .vertical)
      return lb
    }()
    
    private let dateLabel: UILabel = {
      let lb = UILabel()
      lb.font = .preferredFont(forTextStyle: .footnote)
      lb.translatesAutoresizingMaskIntoConstraints = false
      lb.setContentHuggingPriority(.required, for: .vertical)
      return lb
    }()
    
    var article: Article? { didSet { updateUI() } }

    private func updateUI() {
        titleLabel.text = article?.title
        let date = article?.createdAt.foundationDate.datatypeValue.split(separator: "T").compactMap { "\($0)" }
        dateLabel.text = date?[0]
        if let urlStr = article!.image, let thumbnailURL = URL(string: urlStr) {
        thumbnailView.sd_setImage(with: thumbnailURL)
      } else {
        thumbnailView.image = nil
      }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      contentView.backgroundColor = .backgroundColor
      let vStackView = VerticalStackView(arrangedSubviews: [titleLabel, dateLabel], spacing: 8, alignment: .firstBaseline, distribution: .fill)
      let hStackView = HorizontalStackView(arrangedSubviews: [thumbnailView, vStackView], spacing: 16, alignment: .center, distribution: .fill)
      contentView.addSubview(hStackView)
      hStackView.matchParent(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

}
