//
//  Scrollable.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

 protocol Scrollable: class {
  var contentOffset: CGPoint { get }
  var contentInset: UIEdgeInsets { get set }
  var scrollIndicatorInsets: UIEdgeInsets { get set }
  var contentSize: CGSize { get }
  var frame: CGRect { get }
  var contentSizeObservable: Observable<CGSize> { get }
  var contentOffsetObservable: Observable<CGPoint> { get }
    var panGestureStateObservable: Observable<UIGestureRecognizer.State> { get }
  func updateContentOffset(_ contentOffset: CGPoint, animated: Bool)
}

// MARK: - UIScrollView + Scrollable
extension UIScrollView: Scrollable {
  var contentSizeObservable: Observable<CGSize> {
    return KVObservable<CGSize>(keyPath: #keyPath(UIScrollView.contentSize), object: self)
  }
  
  var contentOffsetObservable: Observable<CGPoint> {
    return KVObservable<CGPoint>(keyPath: #keyPath(UIScrollView.contentOffset), object: self)
  }
  
    var panGestureStateObservable: Observable<UIGestureRecognizer.State> {
    return GestureStateObservable(gestureRecognizer: panGestureRecognizer)
  }
  
  func updateContentOffset(_ contentOffset: CGPoint, animated: Bool) {
    // Останавливает торможение
    setContentOffset(self.contentOffset, animated: false)

    let animate = {
      self.contentOffset = contentOffset
    }

    guard animated else {
      animate()
      return
    }

    UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
      animate()
    }, completion: nil)
  }
}
