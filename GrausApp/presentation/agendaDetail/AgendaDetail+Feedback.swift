//
//  AgendaDetails+Feedback.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 7/18/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFeedback

struct AgendaDetailFeedback {
    
    //Reactions
    static func shouldLoadDataReaction(agendaEvent: AgendaEvent) -> (Driver<AgendaDetailState>) -> Driver<AgendaDetailEvent> {
        
        let query:(AgendaDetailState) -> Bool?
            = { $0.shouldLoadData }
        
        let effects:(Bool) -> Driver<AgendaDetailEvent>
            = { shouldLoadDataEffects(shouldLoadData: $0, agendaEvent: agendaEvent) }
        
        return react(query: query, effects: effects)
    }

}

//Effects
fileprivate func shouldLoadDataEffects(shouldLoadData: Bool, agendaEvent: AgendaEvent) -> Driver<AgendaDetailEvent>{
    
    if(shouldLoadData){
        return Driver.just(agendaEvent).map(AgendaDetailEvent.response)
    }
    return Driver.empty()
}



