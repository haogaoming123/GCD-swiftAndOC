//
//  GCD-Swift.swift
//  GCD-Test
//
//  Created by 宝宝 on 2018/4/17.
//  Copyright © 2018年 宝宝. All rights reserved.
//

import Cocoa

class GCD_Swift: NSObject {
    /***** DispatchQueue *****/
    
}

// MARK: - GCD介绍之DispatchQueue
// - DispatchQueue是一个对象，它将任务以FIFO(先到先执行)的顺序执行，它可以是串行的也可以是并发的。它有三个队列类型：main queue、global queue、custom queue
extension GCD_Swift {
    
    /// 创建main queue（串行）：运行在主线程，主要用于UI刷新
    func DispatchQueue_mainQueue() {
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            print("主线程UI刷新")
        }
    }
    
    /// 创建global queue（并行）：如果执行非UI相关的操作时使用
    func DispatchQueue_globalQueue() {
        //global queue队列有四种优先级：高、缺省、低、后台，在实际申请global queue时，不用制定优先级，只需要申明(QoS)，QoS间接的决定了优先级
        DispatchQueue.global(qos: .userInteractive)
        DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.global(qos: .default)
        DispatchQueue.global(qos: .utility)
        DispatchQueue.global(qos: .background)
        //userInteractive：任务必须立即完成，主要用于UI刷新，低延迟的事件处理。最高优先级
        //userInitiated：用于UI发起异步任务，用户在等待执行的结果。高优先级
        //default：默认的级别，它相当于DispatchQueue.global()
        //utility：用于长时间执行的任务，比如app中会有一个进度条表示任务的进行，主要用于计算、IO、网络交互等。低优先级
        //background：任务在运行，但是用户感觉不到的场景，这种queue是后台优先级。最低优先级
    }
}
