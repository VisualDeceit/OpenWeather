//
//  CityTableViewCell.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 18.12.2020.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        cityImageView.image = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityImageView.contentMode = .scaleAspectFill
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 1.0).cgColor, UIColor(white: 1, alpha: 0.5).cgColor,
                           UIColor(white: 1, alpha: 0.0).cgColor]
        gradient.locations = [0.0,  0.5,  1.0]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.opacity = 1
        cityImageView.layer.addSublayer(gradient)
        gradient.frame = contentView.bounds

    }

    
}
