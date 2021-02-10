//
//  WeatherViewController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet var myWatherCollectionView: WeatherCollectionView!
    @IBOutlet var weekDayPicker: WeekDayPicker!
    
    var weathers: List<Weather>!
 
    var token: NotificationToken?
    

    var currentCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDayPicker.addTarget(self, action: #selector(dayIsSelected), for: .valueChanged)
        //регистрируем ячейку
        myWatherCollectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
        
        let networkService = NetworkService()
        networkService.requestWeather(for: currentCity)
       
        pairTableAndRealm()

    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm(), let city = realm.object(ofType: City.self, forPrimaryKey: currentCity) else { return }
        
        weathers = city.weathers

        token = weathers?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.myWatherCollectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    
    //обрабатываем 
    @objc func dayIsSelected(){
        print(weekDayPicker.selectedDay?.title ?? "")
    }

}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weathers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as?
        WeatherCell
        else { return UICollectionViewCell() }
        if let weather = weathers?[indexPath.row] {
        cell.populate(with: weather)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let size = CGSize(width: width, height: width)
        return size
    }
    
    
}
