//
//  AboutUsViewController.swift
//  UITest
//
//  Created by WendaLi on 2020-07-02.
//  Copyright © 2020 WendaLi. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let containerView = UIView()
        let image: UIImageView = {
            let iv = UIImageView()
            let userImageHeightAndWidth = 100
            iv.image = UIImage(named: "userImage")
            iv.frame  = CGRect(x: 0, y: 0, width: userImageHeightAndWidth, height: userImageHeightAndWidth)
            iv.layer.cornerRadius = iv.frame.size.width / 2
            iv.clipsToBounds = true
            iv.layer.borderColor = UIColor.white.cgColor
            iv.layer.borderWidth = 1
            iv.constraintWidth(equalToConstant: CGFloat(userImageHeightAndWidth), heightEqualToConstant: CGFloat(userImageHeightAndWidth))
            return iv
        }()
        containerView.addSubview(image)
        image.anchors(topAnchor: containerView.topAnchor, leadingAnchor: nil, trailingAnchor: nil, bottomAnchor: nil)
        image.centerXYin(containerView)
        view.addSubview(containerView)
        containerView.constraintHeight(equalToConstant: 100)
        containerView.anchors(topAnchor: view.safeAreaLayoutGuide.topAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: .zero)
        
        let text: UITextView = {
            let tt = UITextView()
            tt.font = .preferredFont(forTextStyle: .body)
            tt.textAlignment = .center
            return tt
        }()
        text.text = "LittleSkyGreatGround is the official app of the LittleSkyGreatGround channel, which is designed to provide parents and moms with good book sharing and parenting experience sharing.\n\nFor all suggestions, usage feedback, and help, please go to WeChat to search Xiaotiandadi WeChat public account, and contact customer service to help you answer your questions.\n\nLittleSkyGreatGround\n "
        view.addSubview(text)
        text.anchors(topAnchor: containerView.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, bottomAnchor: view.bottomAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: .zero)
    }

}
