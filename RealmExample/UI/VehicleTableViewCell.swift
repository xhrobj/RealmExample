//
//  RocketTableViewCell.swift
//  RealmExample
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var vehicleImageView: UIImageView!
    
    func setup(name: String, description: String, image: UIImage?) {
        nameLabel.text = name
        descriptionLabel.text = description
        vehicleImageView.image = image
    }
}
