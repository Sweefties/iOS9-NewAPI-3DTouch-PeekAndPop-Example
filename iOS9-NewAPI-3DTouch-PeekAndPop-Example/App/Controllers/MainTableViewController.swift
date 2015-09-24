//
//  MainTableViewController.swift
//  iOS9-NewAPI-3DTouch-PeekAndPop-Example
//
//  Created by Wlad Dicario on 24/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit


class MainTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    let cellID = "defaultCell"
    let segueID = "showDetail"
    let storyboardPreviewID = "DetailPreviewVC"
    var DataSetted = [DataForPreview]()
    var alertController: UIAlertController?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set datas
        populateData()
        // Force touch feature
        if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
            // register UIViewControllerPreviewingDelegate to enable Peek & Pop
            registerForPreviewingWithDelegate(self, sourceView: view)
        }else {
            // 3DTouch Unavailable : present alertController
            alertController = UIAlertController(title: "3DTouch Unavailable", message: "Unsupported device.", preferredStyle: .Alert)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let alertController = alertController {
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
            self.alertController = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK: - MainTableViewDataSource -> MainTableViewController Extension
typealias MainTableViewDataSource = MainTableViewController
extension MainTableViewDataSource {
    
    /// Number of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /// Number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSetted.count ?? 0
    }
    /// Cell for row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        // Configure the cell...
        let row = DataSetted[indexPath.row]
        cell.textLabel?.text = row.question
        cell.detailTextLabel?.text = row.annotation
        return cell
    }
}


//MARK: - MainTableViewDelegate -> MainTableViewController Extension
typealias MainTableViewDelegate = MainTableViewController
extension MainTableViewDelegate {
    
    /// Select Row at IndexPath
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(segueID, sender: self)
    }
}


//MARK: - MainNavigation -> MainTableViewController Extension
typealias MainNavigation = MainTableViewController
extension MainNavigation {
    
    /// Segue Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueID, let indexPath = tableView.indexPathForSelectedRow {
            let previewItem = DataSetted[indexPath.row]
            let detailViewController = segue.destinationViewController as! DetailsViewController
            
            detailViewController.detailTitle = previewItem.title
            detailViewController.detailAnnotation = previewItem.annotation
            detailViewController.detailLatitude = previewItem.latitude
            detailViewController.detailLongitude = previewItem.longitude
        }
    }
}


//MARK: - PeekAndPopPreview -> MainTableViewController Extension
typealias PeekAndPopPreview = MainTableViewController
extension PeekAndPopPreview : UIViewControllerPreviewingDelegate {
    
    /// Called when the user has pressed a source view in a previewing view controller (Peek).
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // Get indexPath for location (CGPoint) + cell (for sourceRect)
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        // Instantiate VC with Identifier (Storyboard ID)
        guard let previewViewController = storyboard?.instantiateViewControllerWithIdentifier(storyboardPreviewID) as? DetailsViewController else { return nil }
        
        // Pass datas to the previewing context
        let previewItem = DataSetted[indexPath.row]
        
        previewViewController.detailTitle = previewItem.title
        previewViewController.detailAnnotation = previewItem.annotation
        previewViewController.detailLatitude = previewItem.latitude
        previewViewController.detailLongitude = previewItem.longitude
        
        // Preferred Content Size for Preview (CGSize)
        previewViewController.preferredContentSize = CGSize(width: 0.0, height: previewItem.currentHeight)
        
        // Current context Source.
        previewingContext.sourceRect = cell.frame
        
        return previewViewController
    }
    /// Called to let you prepare the presentation of a commit (Pop).
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        // Presents viewControllerToCommit in a primary context
        showViewController(viewControllerToCommit, sender: self)
    }
}


//MARK: - DataSet -> MainTableViewController Extension
typealias DataSet = MainTableViewController
extension DataSet {

    struct DataForPreview {
        let question: String
        let title: String
        let annotation: String
        let longitude: Double
        let latitude: Double
        let currentHeight: Double // 0.0 to get the default height.
    }
    
    func populateData() {
        DataSetted = [
            DataForPreview(question: "Where is London?",
                title: "London",
                annotation: "Big Ben",
                longitude: -0.1246402,
                latitude: 51.50007773,
                currentHeight: 0.0),
            DataForPreview(question: "Where is Paris?",
                title: "Paris",
                annotation: "Tour Eiffel",
                longitude: 2.294619083404541,
                latitude: 48.85807994406229,
                currentHeight: 0.0),
            DataForPreview(question: "Where is Barcelona?",
                title: "Barcelona",
                annotation: "Sagrada Familia",
                longitude: 2.174290000000042,
                latitude: 41.404499,
                currentHeight: 320.0),
            DataForPreview(question: "Where is Cupertino?",
                title: "Cupertino",
                annotation: "Apple",
                longitude: -122.03018400000002,
                latitude: 37.331712,
                currentHeight: 0.0),
            DataForPreview(question: "Where is Le Mont St Michel?",
                title: "France",
                annotation: "Manche",
                longitude: -1.5111140000000205,
                latitude: 48.636017,
                currentHeight: 0.0)
        ]
        self.tableView.reloadData()
    }
}