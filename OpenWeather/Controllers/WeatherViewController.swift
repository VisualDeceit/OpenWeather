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
    
    // массив с погодой
        var weathers = [Weather]()

    var currentCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDayPicker.addTarget(self, action: #selector(dayIsSelected), for: .valueChanged)
        //регистрируем ячейку
        myWatherCollectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
        
        let networkService = NetworkService()
        networkService.requestWeather(for: "\(currentCity)") { [weak self] in
            //self?.weathers = weathers
            self?.loadData()
            self?.myWatherCollectionView.reloadData()
        }
    }
    
    func loadData() {
            do {
                let realm = try Realm()
                let weathers = realm.objects(Weather.self).filter("city == %@", currentCity)
                self.weathers = Array(weathers)
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
    }
    
    //обрабатываем 
    @objc func dayIsSelected(){
        print(weekDayPicker.selectedDay?.title ?? "")
    }

}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as?
        WeatherCell
        else { return UICollectionViewCell() }
        cell.populate(with: weathers[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let size = CGSize(width: width, height: width)
        return size
    }
    
    
}
