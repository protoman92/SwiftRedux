//
//  NavigationController.swift
//  CompleteRedux-Demo
//
//  Created by Hai Pham on 11/27/18.
//  Copyright © 2018 Hai Pham. All rights reserved.
//

import CompleteRedux
import UIKit

final class NavigationController: UINavigationController {
  var dependency: Dependency?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }
}

extension NavigationController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    switch viewController {
    case let vc as RootController:
      self.dependency?.injector.injectProps(controller: vc, outProps: ())
      
    case let vc as ViewController1:
      self.dependency?.injector.injectProps(controller: vc, outProps: ())
      
    default:
      fatalError()
    }
  }
}
