//
//  ViewController.swift
//  RealmExample
//

import UIKit
import Combine

class RocketsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel = RocketsViewModel()
    var rocketsSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.allowsSelection = false
        spinner.startAnimating()
        
        rocketsSubscriber = viewModel.$rockets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rockets in
                self?.tableView.reloadData()
                if !rockets.isEmpty {
                    self?.spinner.stopAnimating()
                }
        }
    }
}

extension RocketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rockets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath) as? VehicleTableViewCell else {
            return UITableViewCell()
        }
        let rocket = viewModel.rockets[indexPath.row]
        var image: UIImage? = nil
        if let imageData = rocket.imageData {
            image = UIImage(data: imageData)
        }
        cell.setup(name: rocket.name, description: rocket.title, image: image)
        return cell
    }
}
