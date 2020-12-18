//
//  MyCitiesTableViewController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class MyCitiesTableViewController: UITableViewController {
    
    var cities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityCell_ID")
    }
    
    
    // MARK: - Добавление города
    @IBAction func addCity(segue: UIStoryboardSegue) {
        // Проверяем идентификатор перехода, чтобы убедиться, что это нужный
        if segue.identifier == "addCity" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            guard let allCitiesController = segue.source as? CitiesListTableViewController else { return }
            // Получаем индекс выделенной ячейки
            if let indexPath = allCitiesController.tableView.indexPathForSelectedRow {
                // Получаем город по индексу
                let city = allCitiesController.cities[indexPath.row]
                // Проверяем, что такого города нет в списке
                if !cities.contains(city) {
                    // Добавляем город в список выбранных
                    cities.append(city)
                    // Обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
        
        
    }
    
    
    // MARK: - Table view data source
    
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        performSegue(withIdentifier: "ShowForecast", sender: nil)
    }

    
}


