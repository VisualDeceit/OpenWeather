//
//  MyCityTableViewCell.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class MyCityTableViewCell: UITableViewCell {

    @IBOutlet var cityName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
