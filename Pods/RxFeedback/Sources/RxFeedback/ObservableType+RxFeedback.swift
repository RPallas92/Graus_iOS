//
//  ObservableType+Extensions.swift
//  RxFeedback
//
//  Created by Krunoslav Zaher on 4/30/17.
//  Copyright © 2017 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType where E == Any {
    /**
     Simulation of a discrete system (finite-state machine) with feedback loops.
     Interpretations:
     - [system with feedback loops](https://en.wikipedia.org/wiki/Control_theory)
     - [fixpoint solver](https://en.wikipedia.org/wiki/Fixed_point)
     - [local equilibrium point calculator](https://en.wikipedia.org/wiki/Mechanical_equilibrium)
     - ....

     System simulation will be started upon subscription and stopped after subscription is disposed.

     System state is represented as a `State` parameter.
     Events are represented by `Event` parameter.

     - parameter initialState: Initial state of the system.
     - parameter accumulator: Calculates new system state from existing state and a transition event (system integrator, reducer).
     - parameter feedback: Feedback loops that produce events depending on current system state.
     - returns: Current state of the system.
     */
    public static func system<State, Event>(
            initialState: State,
            reduce: @escaping (State, Event) -> State,
            scheduler: SchedulerType,
            feedback: [(Observable<State>) -> Observable<Event>]
        ) -> Observable<State> {
        return Observable<State>.deferred {
            let replaySubject = ReplaySubject<State>.create(bufferSize: 1)

            let events: Observable<Event> = Observable.merge(feedback.map { $0(replaySubject.asObservable()) })
                .observeOn(scheduler)

            return events.scan(initialState, accumulator: reduce)
                .startWith(initialState)
                .do(onNext: { output in
                    replaySubject.onNext(output)
                })
        }
    }

    public static func system<State, Event>(
            initialState: State,
            reduce: @escaping (State, Event) -> State,
            scheduler: SchedulerType,
            feedback: (Observable<State>) -> Observable<Event>...
        ) -> Observable<State> {
        return system(initialState: initialState, reduce: reduce, scheduler: scheduler, feedback: feedback)
    }
}

extension SharedSequenceConvertibleType where E == Any {
    /**
     Simulation of a discrete system (finite-state machine) with feedback loops.
     Interpretations:
     - [system with feedback loops](https://en.wikipedia.org/wiki/Control_theory)
     - [fixpoint solver](https://en.wikipedia.org/wiki/Fixed_point)
     - [local equilibrium point calculator](https://en.wikipedia.org/wiki/Mechanical_equilibrium)
     - ....

     System simulation will be started upon subscription and stopped after subscription is disposed.

     System state is represented as a `State` parameter.
     Events are represented by `Event` parameter.

     - parameter initialState: Initial state of the system.
     - parameter accumulator: Calculates new system state from existing state and a transition event (system integrator, reducer).
     - parameter feedback: Feedback loops that produce events depending on current system state.
     - returns: Current state of the system.
     */
    public static func system<State, Event>(
            initialState: State,
            reduce: @escaping (State, Event) -> State,
            feedback: [(SharedSequence<SharingStrategy, State>) -> SharedSequence<SharingStrategy, Event>]
        ) -> SharedSequence<SharingStrategy, State> {
        return SharedSequence<SharingStrategy, State>.deferred {
            let replaySubject = ReplaySubject<State>.create(bufferSize: 1)

            let outputDriver = replaySubject.asSharedSequence(onErrorDriveWith: SharedSequence<SharingStrategy, State>.empty())

            let events = SharedSequence.merge(feedback.map { $0(outputDriver) })

            return events.scan(initialState, accumulator: reduce)
                .startWith(initialState)
                .do(onNext: { output in
                    replaySubject.onNext(output)
                })
        }
    }

    public static func system<State, Event>(
            initialState: State,
            reduce: @escaping (State, Event) -> State,
            feedback: (SharedSequence<SharingStrategy, State>) -> SharedSequence<SharingStrategy, Event>...
        ) -> SharedSequence<SharingStrategy, State> {
        return system(initialState: initialState, reduce: reduce, feedback: feedback)
    }
}
