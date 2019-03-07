//
//  EventsTableViewCell.swift
//  TestTaskSibintek-soft_EreskinVA
//
//  Created by Vladimir Ereskin on 06/03/2019.
//  Copyright © 2019 Vladimir Ereskin. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    var link: ScheduleOfEventsTVC?
    
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var venue: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var participant: UILabel!
    @IBOutlet var imageParticipant: UIImageView!
    @IBOutlet var imageName: UIImageView!
    @IBOutlet var starButton: UIButton!
    @IBOutlet var participantStackView: UIStackView!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCell.layer.cornerRadius = 6
        
        imageParticipant.layer.cornerRadius = imageParticipant.bounds.height / 2
        imageParticipant.layer.masksToBounds = true
        
        imageName.layer.cornerRadius = 4
        imageName.layer.masksToBounds = true
    }

    @IBAction func faforiteButtonPress(_ sender: UIButton) {
        link?.favoriteTapped(cell: self)
    }
    
}
