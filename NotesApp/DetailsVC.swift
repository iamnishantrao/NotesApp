//
//  DetailsVC.swift
//  NotesApp
//
//  Created by Nishant on 05/08/17.
//  Copyright © 2017 rao. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var noteToEdit: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        //for editing a saved item
        if noteToEdit != nil {
            
            loadNoteData()
        }

    }
    
    func loadNoteData() {
        
        if let note = noteToEdit {
            
            titleTextField.text = note.title
            detailsTextView.text = note.details
        }
    }
    
    // Function to Sava Note.
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        var note: Note!
        
        if noteToEdit == nil {
            
            note = Note(context: context)
        } else {
            
            note = noteToEdit
        }
        
        if let title = titleTextField.text {
            
            note.title = title
        }
        
        if let details = detailsTextView.text {
            
            note.details = details
        }
        
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)

    }
    
    // Function to Delete Note.
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
                
        if noteToEdit != nil {
            
            context.delete(noteToEdit!)
            appDelegate.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}
