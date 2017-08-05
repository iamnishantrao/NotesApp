//
//  NotesCell.swift
//  NotesApp
//
//  Created by Nishant on 05/08/17.
//  Copyright © 2017 rao. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configureCell(note: Note) {
        
        titleLabel.text = note.title
        detailsLabel.text = note.details
        
    }
}
