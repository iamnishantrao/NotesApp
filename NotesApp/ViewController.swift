//
//  ViewController.swift
//  NotesApp
//
//  Created by Nishant on 05/08/17.
//  Copyright © 2017 rao. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //for NSFetchResult with "Note" from where we want to fetch data
    var controller: NSFetchedResultsController<Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        generateTestData()
        attemptFetch()
    }
    
    // Table View Functions.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            let note = objs[indexPath.row]
            performSegue(withIdentifier: "ShowDetails", sender: note)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetails" {
            
            if let destination = segue.destination as? DetailsVC {
                
                if let note = sender as? Note {
                    
                    destination.noteToEdit = note
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    // Function to Configure Cell.
    func configureCell(cell: NotesCell, indexPath: NSIndexPath) {
        
        let note = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(note: note)
    }

    // Function for NSFetchRequest.
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        // For sorting notes according to Name and Date Created.
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let nameSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [nameSort]
            
        }
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        do {
            
            try controller.performFetch()
        } catch {
            
            let err = error as NSError
            print(err.debugDescription)
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! NotesCell
                
                //"configureCell" of "MainVC" is called
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade
                )
            }
            break
            
        }
    }
    
    // Function for Segments.
    @IBAction func segmentChanged(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
    }

    func generateTestData() {
        
        let note = Note(context: context)
        note.title = "Hello World"
        note.details = "First Note."
        
        appDelegate.saveContext()
    }
}


