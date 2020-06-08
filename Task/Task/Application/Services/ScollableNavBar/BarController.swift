//
//  BarController.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
 typealias StateObserver = (State) -> Void

private struct ScrollableObservables {
  let contentOffset: Observable<CGPoint>
  let contentSize: Observable<CGSize>
    let panGestureState: Observable<UIGestureRecognizer.State>
}

public class BarController {
  
  private let stateReducer: StateReducer
  private let configuration: Configuration
  private let stateObserver: StateObserver

  private var state: State {
    didSet { stateObserver(state) }
  }
  
  private weak var scrollable: Scrollable?
  private var observables: ScrollableObservables?
  
  // MARK: - Lifecycle
  internal init(
    stateReducer: @escaping StateReducer,
    configuration: Configuration,
    stateObserver: @escaping StateObserver
  ) {
    self.stateReducer = stateReducer
    self.configuration = configuration
    self.stateObserver = stateObserver
    self.state = State(
      offset: -configuration.normalStateHeight,
      isExpandedStateAvailable: false,
      configuration: configuration
    )
  }
}


 struct StateReducerParameters {
  let scrollable: Scrollable
  let configuration: Configuration
  let previousContentOffset: CGPoint
  let contentOffset: CGPoint
  let state: State
}

 typealias StateReducer = (StateReducerParameters) -> State
