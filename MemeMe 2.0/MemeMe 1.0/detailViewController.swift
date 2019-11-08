//
//  detailViewController.swift
//  MemeMe 1.0
//
//  Created by Lola M on 5/11/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    let meme = Meme.self
    
    init(meme: Meme) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        let imageview = UIImageView()
        
        view.addSubview(imageview)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        imageview.image = meme.memedImage
        imageview.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
