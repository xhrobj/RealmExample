//
//  ViewController.swift
//  RealmExample
//

import UIKit
import Combine

class ShipsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel = ShipsViewModel()
    var shipsSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.allowsSelection = false
        spinner.startAnimating()
        
        shipsSubscriber = viewModel.$ships
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ships in
                self?.tableView.reloadData()
                if !ships.isEmpty {
                    self?.spinner.stopAnimating()
                }
        }
    }
}

extension ShipsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.ships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShipCell", for: indexPath) as? VehicleTableViewCell else {
            return UITableViewCell()
        }
        let ship = viewModel.ships[indexPath.row]
        var image: UIImage? = nil
        if let imageData = ship.imageData {
            image = UIImage(data: imageData)
        }
        cell.setup(name: ship.name, description: ship.homePort, image: image)
        return cell
    }
}
