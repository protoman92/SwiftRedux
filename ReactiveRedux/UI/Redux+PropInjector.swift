//
//  Redux+PropInjector.swift
//  ReactiveRedux
//
//  Created by Hai Pham on 12/2/18.
//  Copyright © 2018 Hai Pham. All rights reserved.
//

public extension Redux.UI {
  
  /// Basic redux injector implementation that also handles view lifecycles.
  public struct PropInjector<State>: ReduxPropInjectorType {
    private let store: Redux.Store.DelegateStore<State>
    
    public init<S>(store: S) where S: ReduxStoreType, S.State == State {
      self.store = Redux.Store.DelegateStore(store)
    }
    
    func _inject<CV, MP>(_ cv: CV, _ outProps: CV.OutProps, _ mapper: MP.Type)
      -> Redux.Store.Subscription where
      CV.PropInjector == PropInjector,
      MP: ReduxPropMapperType,
      MP.ReduxState == State,
      MP.ReduxView == CV
    {
      let dispatch = self.store.dispatch
      
      // Here we use the view's class name and a timestamp as the subscription
      // id. We don't even need to store this id because we can simply cancel
      // with the returned subscription callback (so the id can be literally
      // anything, as long as it is unique).
      let timestamp = Date().timeIntervalSince1970
      let viewId = String(describing: cv) + String(describing: timestamp)
      var previous: CV.StateProps? = nil
      var first = true
      
      // If there has been a previous subscription, unsubscribe from it to avoid
      // having parallel subscriptions.
      cv.staticProps?.subscription.unsubscribe()
      
      let unsubscribe = self.store
        .subscribeState(viewId) {[weak cv] state in
          // Since UI operations must happen on the main thread, we dispatch
          // with the main queue. Setting the previous props here is ok as well
          // since only the main queue is accessing it.
          DispatchQueue.main.async {
            let dispatch = MP.mapAction(dispatch: dispatch, outProps: outProps)
            let next = MP.mapState(state: state, outProps: outProps)
            
            if first || !MP.compareState(lhs: previous, rhs: next) {
              cv?.variableProps = VariableProps(first, previous, next, dispatch)
              previous = next
              first = false
            }
          }
      }
      
      cv.staticProps = StaticProps(self, unsubscribe)
      return unsubscribe
    }
    
    @discardableResult
    public func injectProps<VC, MP>(controller: VC,
                                    outProps: VC.OutProps,
                                    mapper: MP.Type)
      -> Redux.Store.Subscription where
      VC: UIViewController,
      VC.PropInjector == PropInjector,
      MP: ReduxPropMapperType,
      MP.ReduxState == State,
      MP.ReduxView == VC
    {
      let subscription = self._inject(controller, outProps, mapper)
      let lifecycleVC = LifecycleViewController()
      lifecycleVC.onDeinit = subscription.unsubscribe
      controller.addChild(lifecycleVC)
      return subscription
    }
    
    @discardableResult
    public func injectProps<V, MP>(view: V,
                                   outProps: V.OutProps,
                                   mapper: MP.Type)
      -> Redux.Store.Subscription where
      V: UIView,
      V.PropInjector == PropInjector,
      MP: ReduxPropMapperType,
      MP.ReduxState == State,
      MP.ReduxView == V
    {
      let subscription = self._inject(view, outProps, mapper)
      let lifecycleView = LifecycleView()
      lifecycleView.onDeinit = subscription.unsubscribe
      view.addSubview(lifecycleView)
      return subscription
    }
  }
}

extension Redux.UI.PropInjector {
  final class LifecycleViewController: UIViewController {
    deinit { self.onDeinit?() }
    var onDeinit: (() -> Void)?
  }
  
  final class LifecycleView: UIView {
    deinit { self.onDeinit?() }
    var onDeinit: (() -> Void)?
  }
}