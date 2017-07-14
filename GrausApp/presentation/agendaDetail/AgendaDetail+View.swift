//
//  AgendaEvent+View.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 03/07/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxFeedback


class AgendaDetailViewController: UITableViewController {
    
    var agendaEvent: AgendaEvent!
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address1Label: UILabel!
    
    
    func initDetailsLabel(){
        let font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
         let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineHeightMultiple = 20.0
         paragraphStyle.maximumLineHeight = 20.0
         paragraphStyle.minimumLineHeight = 20.0
         let color = UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1.0)
         let attributedDetails = NSMutableAttributedString(string: agendaEvent.description, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: color])
         detailsLabel.attributedText = attributedDetails;
    }
    
    
    func initMapView() {
        var region = MKCoordinateRegion()
        region.center.latitude = CLLocationDegrees(agendaEvent.lat)
        region.center.longitude = CLLocationDegrees(agendaEvent.lon)
        region.span.latitudeDelta = 0.00075
        region.span.longitudeDelta = 0.00075
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(agendaEvent.lat), CLLocationDegrees(agendaEvent.lon))
        mapView.addAnnotation(annotation)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Self sizing cells
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        initUI()
        
    }
    
    func initUI(){
        titleLabel.text = agendaEvent.name
        
        if let thumbnailUrl = agendaEvent.imageThumbnailUrl {
            let url = URL(string: thumbnailUrl)
            logoImageView.pin_setImage(from: url)
        }
        
        
        dateLabel.text = agendaEvent.date.toReadableString()
        hoursLabel.text = agendaEvent.date.toHourString()
        address1Label.text = agendaEvent.city
        
        initMapView()
        initDetailsLabel()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.row == 6 { // Xcode Bug #2
            cell.backgroundColor = UIColor(red: 106.0/255.0, green: 118.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
    
    
    
    
}
