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
        
        
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 3
    }
    
    
    override func prepareForReuse() {
        imageView.image = nil
        tempLabel.text = nil
        dateLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //contentView.layer.shadowPath = UIBezierPath(roundedRect: canvas.bounds, cornerRadius: 20).cgPath
        
        canvas.layer.cornerRadius = canvas.frame.height / 2
    }

}
