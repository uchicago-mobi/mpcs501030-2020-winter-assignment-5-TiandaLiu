//
//  FavoritesViewController.swift
//  Assignment-5
//
//  Created by TIANDA LIU on 2/13/20.
//  Copyright © 2020 TIANDA LIU. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UITableViewController {
    @IBOutlet var backButton: UIButton!
    
    weak var delegate: PlacesFavoritesDelegate?
    let favList = UserDefaults.standard.object(forKey: "FavList") as! [String]
    
    @objc func handleClick(_ button: UIButton) {
        print("tapped")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        backButton.addTarget(self, action: #selector(handleClick(_:)), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath)
        cell.textLabel?.text = self.favList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            self.delegate?.favoritePlace(name: self.favList[indexPath.row])
        })
    }
    
}
