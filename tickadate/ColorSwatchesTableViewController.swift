//
//  ColorSwatchesTableViewController.swift
//  tickadate
//
//  Created by Romain Bessuges-Meusy on 01/06/2017.
//  Copyright © 2017 Agilitation. All rights reserved.
//

import UIKit

class ColorSwatchesTableViewController: UITableViewController {
  
  var swatches:[ColorSwatch] = []
  
  var detailVC:ColorSwatchPreviewCollectionViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.reload()
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name("colorSwatches.change"), object: nil, queue: nil) { (notif) in
      self.reload()
    }

  }
  
  func reload() {
    ColorSwatchesManager.shared.fetchAvailableColorSwatches { (swatches) in
      self.swatches = swatches
      self.tableView.reloadData()
    }
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return swatches.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if detailVC != nil {
      detailVC!.colorSwatch = self.swatches[indexPath.item]
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    detailVC = segue.destination as? ColorSwatchPreviewCollectionViewController
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColorSwatchTableViewCell
    
    let csd:ColorSwatch = self.swatches[indexPath.item]
    cell.nameLabel.text = csd.name
    cell.descriptionLabel.text = csd.description
    cell.accessoryType = IAPManager.shared.activeColorSwatchesIds.contains(csd.productID) ? .checkmark : .none
    
    return cell
  }
}
