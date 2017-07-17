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
    
    private let disposeBag = DisposeBag()
    var agendaEvent: AgendaEvent!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address1Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let noUiEvents: (Driver<AgendaDetailState>) -> Driver<AgendaDetailEvent> = { state in
            return state.flatMapLatest { state -> Driver<AgendaDetailEvent> in
                return Driver.empty()
            }
        }
        
        let bindUI: (Driver<AgendaDetailState>) -> Driver<AgendaDetailEvent> = UI.bind(self) { me, state in
            let subscriptions = [
                state.map { $0.event?.name }.drive(me.titleLabel.rx.text),
                state.map { $0.event?.date.toReadableString() }.drive(me.dateLabel.rx.text),
                state.map { $0.event?.date.toHourString() }.drive(me.hoursLabel.rx.text),
                state.map { $0.event?.city }.drive(me.address1Label.rx.text),
                state.map { me.getAtributeText(from: $0.event?.description) }.drive(me.detailsLabel.rx.attributedText),
                state.map { $0.event?.getUrl() }.drive(onNext: { url in me.logoImageView.pin_setImage(from: url) } , onCompleted: nil, onDisposed: nil),
                state.drive(onNext: { _ in me.initMapView() }, onCompleted: nil, onDisposed: nil)
            ]
            let events = [
                noUiEvents(state)
            ]
            return UI.Bindings(subscriptions: subscriptions, events: events)
        }
        
 
        Driver.system(
            initialState: AgendaDetailState.empty,
            reduce: AgendaDetailState.reduce,
            feedback:
            // UI, user feedback
            bindUI,
            // NoUI, automatic feedback
            react(query: { $0.shouldLoadData}, effects: { shouldLoadData in
                if(shouldLoadData){
                   return Driver.just(self.agendaEvent)
                    .map(AgendaDetailEvent.response)
                }
                return Driver.empty()
            })
            )
            .drive()
            .disposed(by: disposeBag)
        
        
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
    
    func getAtributeText(from text: String?) -> NSMutableAttributedString{
        let font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightLight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 20.0
        paragraphStyle.maximumLineHeight = 20.0
        paragraphStyle.minimumLineHeight = 20.0
        let color = UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        return NSMutableAttributedString(string: text ?? "", attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: color])
    }

    
}
