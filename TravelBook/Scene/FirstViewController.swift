//
//  FirstViewController.swift
//  TravelBook
//
//  Created by Murat Yıldırım on 21.05.2023.
//

import UIKit

class FirstViewController: UIViewController {

  // MARK: IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }
  
  @objc func addButtonClicked() {
    performSegue(withIdentifier: "toSaveVC", sender: nil)
  }
}

extension FirstViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
}

extension FirstViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "test"
    return cell
  }
  
  
}
