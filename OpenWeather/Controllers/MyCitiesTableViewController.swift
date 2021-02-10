//
//  MyCitiesTableViewController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit
import RealmSwift
import FirebaseAuth
import FirebaseDatabase

class MyCitiesTableViewController: UITableViewController {
    
    var cityes: Results<City>?
    var token: NotificationToken?
    
    private var cities = [FirebaseCity]()
    private let ref = Database.database(url: "https://openweather-7de5e-default-rtdb.europe-west1.firebasedatabase.app").reference(withPath: "cities")
    
    @IBAction func addButtonPressed(_ sender: Any) {
        showAddCityForm()
    
    }
    @IBAction func logOutButtonPresswd(_ sender: Any) {
   
//        do {
//            try  Auth.auth().signOut()
//            self.navigationController?.popViewController(animated: true)
//
//        }
//        catch (let error) {
//            print(error)
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "CityCell_ID")
        
        ref.observe(.value) { (snapshot) in
            var cities: [FirebaseCity] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let city = FirebaseCity(snapshot: snapshot) {
                    cities.append(city)
                }
            }
            self.cities = cities
            self.tableView.reloadData()
        }
        
       // pairTableAndRealm()

    }
    
    
    // MARK: - Добавление города
//    @IBAction func addCity(segue: UIStoryboardSegue) {
//        // Проверяем идентификатор перехода, чтобы убедиться, что это нужный
//        if segue.identifier == "addCity" {
//            // Получаем ссылку на контроллер, с которого осуществлен переход
//            guard let allCitiesController = segue.source as? CitiesListTableViewController else { return }
//            // Получаем индекс выделенной ячейки
//            if let indexPath = allCitiesController.tableView.indexPathForSelectedRow {
//                // Получаем город по индексу
//                let city = allCitiesController.cities[indexPath.row]
//                // Проверяем, что такого города нет в списке
//                if !cities.contains(city) {
//                    // Добавляем город в список выбранных
//                    cities.append(city)
//                    // Обновляем таблицу
//                    tableView.reloadData()
//                }
//            }
//        }
//        
//        
//    }
//    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cityes?.count ?? 0
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell_ID", for: indexPath)
                as? CityTableViewCell
        else { return UITableViewCell() }
        
//        if let city = cityes?[indexPath.row] {
//            cell.cityLabel.text = city.name
//        }
        let city = cities[indexPath.row]
        cell.cityLabel.text = city.name
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let city = cityes?[indexPath.row] else {return}

        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(city.weathers)
                realm.delete(city)
                try realm.commitWrite()
            } catch {
                print(error)
            }

//            // Delete the row from the data source
//            cities.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cotroller = segue.destination as? WeatherViewController,
              let currentCity = cityes?[tableView.indexPathForSelectedRow?.row ?? 0].name else {
            return
        }
       
        cotroller.currentCity = currentCity
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm(configuration: Realm.Configuration( deleteRealmIfMigrationNeeded: true)) else { return }
        print(realm.configuration.fileURL ?? "")
        cityes = realm.objects(City.self)
        token = cityes?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func showAddCityForm() {
        let alertController = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        })
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
            guard let name = alertController.textFields?[0].text else { return }
            //self?.addCity(name: name)
            let city = FirebaseCity(name: name, zipcode: Int.random(in: 100000...999999))
            let cityRef = self?.ref.child(name.lowercased())
            cityRef?.setValue(city.toAnyObject())
        }
        
       
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func addCity(name: String) {
        let newCity = City()
        newCity.name = name
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(newCity, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    
    
}


