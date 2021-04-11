//
//  PhotoViewerViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/4/6.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoViewerViewController: UIViewController {

    private let url: URL

    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 414, height: 800))
        return scrollView
    }()
    
    

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.addSubview(imageView)
        imageView.sd_setImage(with: url, completed: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }


}
