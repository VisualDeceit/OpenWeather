//
//  WeatherViewController.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var myWatherCollectionView: WeatherCollectionView!
    @IBOutlet var weekDayPicker: WeekDayPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weekDayPicker.addTarget(self, action: #selector(dayIsSelected), for: .valueChanged)
    }
    
    //обрабатываем 
    @objc func dayIsSelected(){
        print(weekDayPicker.selectedDay?.title ?? "")
    }

}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as?
        WeatherCell
        else { return UICollectionViewCell() }
        
        cell.weather.text = "30 C"
        cell.date.text = "\(Date())"
        return cell
    }
    
    
}
