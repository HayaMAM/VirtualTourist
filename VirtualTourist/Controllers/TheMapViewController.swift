//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 29/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TheMapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var vMap: MKMapView!
    @IBOutlet weak var pinsToEditView: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }

    fileprivate func setUpFetchedResultsController() {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            updateVmap()
        } catch {
            fatalError("The fetch couldn't be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Virtual Tourist"
        navigationItem.rightBarButtonItem = editButtonItem
        pinsToEditView.isHidden = true
        setUpFetchedResultsController()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        pinsToEditView.isHidden = !editing

    }
    
    @IBAction func thisPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
            
            let pinLocation = sender.location(in: vMap)
            let pin = Pin(context: context)
            pin.coordinate = vMap.convert(pinLocation, toCoordinateFrom: vMap)
            try? context.save()
    
        }
    
    func updateVmap() {
        guard let pins = fetchedResultsController.fetchedObjects else { return }
        for pin in pins {
            if vMap.annotations.contains(where: {pin.compare(to: $0.coordinate)}) { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            vMap.addAnnotation(annotation)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SegueToPhotoAlbumViewController" {
        let controller = segue.destination as! PhotoAlbumViewController
        controller.chosenPin = sender as? Pin
    }
}
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       
        let pin = fetchedResultsController.fetchedObjects?.filter { $0.compare(to: view.annotation!.coordinate)}.first!
        let lon = view.annotation?.coordinate.longitude
        let lat = view.annotation?.coordinate.latitude
        guard let annotation = view.annotation else {
            return
        }
        if pin!.latitude == lat, pin!.longitude == lon{
            if isEditing {
                vMap.removeAnnotation(annotation)
                context.delete(pin!)
                try! context.save()
                return
            }
        performSegue(withIdentifier: "SegueToPhotoAlbumViewController", sender: pin)
    }
    }
   
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateVmap()
    }
}


