//
//  YCStore.swift
//  ikangtai
//
//  Created by 罗培克 on 2018/4/13.
//  Copyright © 2018年 北京爱康泰科技有限责任公司. All rights reserved.
//

import UIKit

protocol ActionType {}
protocol CommandType {}
protocol StateType {}

class Store<A: ActionType, S: StateType, C: CommandType> {
    let reducer: (_ state: S, _ action: A) -> (S, C?)
    var subscriber: ((_ state: S, _ previousState: S, _ command: C?) -> Void)?
    var state: S
    
    init(reducer: @escaping (S, A) -> (S, C?), initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func subscribe(_ handler: @escaping (S, S, C?) -> Void) {
        self.subscriber = handler
    }
    
    func unSubscribe() {
        self.subscriber = nil
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        let (nextState, command) = reducer(state, action)
        state = nextState
        subscriber?(state, previousState, command)
    }
}
