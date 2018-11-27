//
//  VacancyTableViewCell.swift
//  HeadHunterSearch
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class VacancyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var employerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
    }
    
    func setupStyle() {
        nameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        nameLabel.textColor = UIColor.black
        
        employerLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        employerLabel.textColor = UIColor.black.withAlphaComponent(0.75)
        
        priceLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        priceLabel.textColor = UIColor.black
    }
}
