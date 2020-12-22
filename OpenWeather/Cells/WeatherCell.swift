//
//  WeatherCell.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 19.12.2020.
//

import UIKit

class WeatherCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var canvas: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    
    override func prepareForReuse() {
        imageView.image = nil
        tempLabel.text = nil
        dateLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //при первом вызове layoutSubviews(), canvas еще не знает правильный размер фрейма
        //поэтому вычисляем через фрейм ячейки
        canvas.layer.cornerRadius = ( self.frame.height -  40) / 2
        
        contentView.backgroundColor = .clear
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 4
        contentView.clipsToBounds = false

        
    }

}
