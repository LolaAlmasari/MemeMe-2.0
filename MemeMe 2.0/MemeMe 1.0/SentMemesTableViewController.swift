//
//  SentMemesTableViewController.swift
//  MemeMe 1.0
//
//  Created by Lola M on 5/4/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UIApplicationDelegate {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let meme = memes[indexPath.row]
        cell?.imageView?.image = meme.memedImage
        cell?.textLabel?.text = "\(meme.topText)... \(meme.bottomText)"
        return cell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(detailViewController(meme: memes[indexPath.row]), animated: true)
    }
}
