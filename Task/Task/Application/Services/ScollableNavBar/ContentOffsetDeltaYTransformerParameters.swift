//
//  ContentOffsetDeltaYTransformerParameters.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

 struct ContentOffsetDeltaYTransformerParameters {
  let scrollable: Scrollable
  let configuration: Configuration
  let previousContentOffset: CGPoint
  let contentOffset: CGPoint
  let state: State
  let contentOffsetDeltaY: CGFloat
}

 typealias ContentOffsetDeltaYTransformer = (ContentOffsetDeltaYTransformerParameters) -> CGFloat

 func makeDefaultStateReducer(transformers: [ContentOffsetDeltaYTransformer]) -> StateReducer {
  return { (params: StateReducerParameters) -> State in
    var deltaY = params.contentOffset.y - params.previousContentOffset.y

    deltaY = transformers.reduce(deltaY) { (deltaY, transformer) -> CGFloat in
      let params = ContentOffsetDeltaYTransformerParameters(
        scrollable: params.scrollable,
        configuration: params.configuration,
        previousContentOffset: params.previousContentOffset,
        contentOffset: params.contentOffset,
        state: params.state,
        contentOffsetDeltaY: deltaY
      )
      return transformer(params)
    }

    return params.state.add(offset: deltaY)
  }
}
