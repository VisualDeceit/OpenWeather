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
    
    // массив с погодой
        var weathers = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDayPicker.addTarget(self, action: #selector(dayIsSelected), for: .valueChanged)
        //регистрируем ячейку
        myWatherCollectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
        
        let networkService = NetworkService()
        networkService.requestWeather(for: "orenburg,ru") { [weak self] weathers in
            self?.weathers = weathers
            self?.myWatherCollectionView.reloadData()
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
