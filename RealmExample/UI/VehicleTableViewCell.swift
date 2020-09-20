//
//  RocketTableViewCell.swift
//  RealmExample
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var vehicleImageView: UIImageView!
    
    var vehicleImageViewConstraint: NSLayoutConstraint?
    
    func setup(name: String, description: String, image: UIImage?) {
        nameLabel.text = name
        descriptionLabel.text = description
        vehicleImageView.image = image
        adjustVehicleImageView()
    }
    
    private func adjustVehicleImageView() {
        vehicleImageView.contentMode = .scaleAspectFit
        guard let imageRate = vehicleImageView.image?.getImageRatio() else {
            return
        }
        vehicleImageViewConstraint = vehicleImageView.heightAnchor.constraint(equalTo: vehicleImageView.widthAnchor, multiplier: 1/imageRate)
        vehicleImageViewConstraint?.priority = UILayoutPriority(rawValue: 750)
        vehicleImageViewConstraint?.isActive = true
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vehicleImageViewConstraint?.isActive = false
        setNeedsLayout()
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
