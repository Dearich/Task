//
//  State.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

 struct State {
   let offset: CGFloat
   let isExpandedStateAvailable: Bool
   let configuration: Configuration

   init(offset: CGFloat, isExpandedStateAvailable: Bool, configuration: Configuration) {
    self.offset = offset
    self.isExpandedStateAvailable = isExpandedStateAvailable
    self.configuration = configuration
  }
}

 struct Configuration {
  let compactStateHeight: CGFloat
  let normalStateHeight: CGFloat
  let expandedStateHeight: CGFloat
}
