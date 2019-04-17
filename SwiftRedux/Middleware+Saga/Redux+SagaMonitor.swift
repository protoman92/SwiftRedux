//
//  Redux+SagaMonitor.swift
//  SwiftRedux
//
//  Created by Viethai Pham on 18/4/19.
//  Copyright © 2019 Hai Pham. All rights reserved.
//

/// Default Saga monitor implementation.
public final class SagaMonitor {
  private typealias UniqueID = UniqueIDProviderType.UniqueID
  private var _dispatchers: [UniqueID : AwaitableReduxDispatcher]
  private let _lock: ReadWriteLockType
  
  public lazy private(set) var dispatch: AwaitableReduxDispatcher = {action in
    self._lock.modify {
      self._dispatchers.forEach {_, value in _ = value(action) }
      return EmptyAwaitable.instance
    }
  }
  
  public init() {
    self._dispatchers = [:]
    self._lock = ReadWriteLock()
  }
}

// MARK: - ReduxDispatcherProviderType
extension SagaMonitor: ReduxDispatcherProviderType {}

// MARK: - SagaMonitorType
extension SagaMonitor: SagaMonitorType {
  public func addDispatcher(_ uniqueID: UniqueIDProviderType.UniqueID,
                            _ dispatch: @escaping AwaitableReduxDispatcher) {
    self._lock.modify { self._dispatchers[uniqueID] = dispatch }
  }
  
  public func removeDispatcher(_ uniqueID: Int64) {
    self._lock.modify { _ = self._dispatchers.removeValue(forKey: uniqueID) }
  }
}