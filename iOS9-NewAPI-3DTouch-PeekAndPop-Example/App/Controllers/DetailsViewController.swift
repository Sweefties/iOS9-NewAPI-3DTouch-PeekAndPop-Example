//
//  DetailsViewController.swift
//  iOS9-NewAPI-3DTouch-PeekAndPop-Example
//
//  Created by Wlad Dicario on 24/09/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit
import MapKit


class DetailsViewController: UIViewController {

    
    // MARK: - Interface
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Properties
    var newLocation = CLLocationCoordinate2D()
    
    var detailTitle: String?
    var detailLatitude: Double?
    var detailLongitude: Double?
    var detailAnnotation: String?
    
    
    // MARK: - Preview action items.
    lazy var previewDetailsActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                guard let detailViewController = viewController as? DetailsViewController,
                    let item = detailViewController.detailTitle else { return }
                
                print("\(previewAction.title) triggered from `DetailsViewController` for item: \(item)")
            }
        }
        
        let actionDefault = previewActionForTitle("Default Action")
        let actionDestructive = previewActionForTitle("Destructive Action", style: .destructive)
        
        let subActionGoTo = previewActionForTitle("Go to coordinates")
        let subActionSave = previewActionForTitle("Save location")
        let groupedOptionsActions = UIPreviewActionGroup(title: "Options…", style: .default, actions: [subActionGoTo, subActionSave] )
        
        return [actionDefault, actionDestructive, groupedOptionsActions]
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // details
        if let currentTitle = detailTitle, let currentAnnotation = detailAnnotation, let currentLatitude = detailLatitude, let currentLongitude = detailLongitude {
            self.title = currentTitle
            renderedMap(currentAnnotation, subtitle: currentTitle, latitude: currentLatitude, longitude: currentLongitude)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//MARK: - MapViewRendered -> DetailsViewController Extension
typealias MapViewRendered = DetailsViewController
extension MapViewRendered : MKMapViewDelegate {
    
    /// Layout MapView
    func renderedMap(_ title:String, subtitle:String, latitude:Double, longitude:Double) {
        newLocation.latitude = latitude
        newLocation.longitude = longitude
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: newLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation
        annotation.title = title
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)
    }
}


//MARK: - PreviewActions -> DetailsViewController Extension
typealias PreviewActions = DetailsViewController
extension PreviewActions  {
    
    /// User swipes upward on a 3D Touch preview
    override var previewActionItems : [UIPreviewActionItem] {
        return previewDetailsActions
    }
}
