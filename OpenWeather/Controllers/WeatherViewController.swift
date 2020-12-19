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
        //регистрируем ячейку
        myWatherCollectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
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
        
        cell.tempLabel.text = "+30"
        cell.dateLabel.text = "\(Int.random(in: 1..<24))ч"
        cell.imageView.image = UIImage(named: "sunny")
        return cell
    }
    
    
}
