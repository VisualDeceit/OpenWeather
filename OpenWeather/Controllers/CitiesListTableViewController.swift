//
//  CitiesListTableViewController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 08.12.2020.
//

import UIKit

class CitiesListTableViewController: UITableViewController {

    var cities = [
        City(name: "moscow", title: "Москва", emblem:  UIImage(named: "Moscow")),
        City(name: "saint petersburg", title: "Санкт-Петербург",  emblem:  UIImage(named: "Piter")),
        City(name: "kolomna", title: "Коломна", emblem:  UIImage(named: "Kolomna")),
        City(name: "voronezh",title: "Воронеж", emblem:UIImage(named: "Voronezh")),
        City(name: "penza",title: "Пенза", emblem:  UIImage(named: "Penza")),
        City(name: "orenburg",title: "Оренбург", emblem:  UIImage(named: "Orenburg")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityCell_ID")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell_ID", for: indexPath)
                as? CityTableViewCell
        else { return UITableViewCell() }
        
        cell.cityLabel.text = cities[indexPath.row].title
        cell.cityImageView.image = cities[indexPath.row].emblem

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "addCity", sender: nil)
    }


}
