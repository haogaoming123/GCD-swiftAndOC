//
//  NSOperation-Swift.swift
//  GCD-Test
//
//  Created by haogaoming on 2018/4/20.
//  Copyright © 2018年 宝宝. All rights reserved.
//

import Cocoa

class NSOperation_Swift: NSObject {
    //GCD是一个底层的C API，operationQueue是基于GCD和队列模型的一个抽象，负责operation的调度。是以面向对象的方式执行任务。
    //和GCD的主要区别：
    //1、operationQueue不遵循FIFO原则，因为operation可以设置依赖，C依赖B，B依赖A，这样执行的顺序就是A -> B -> C
    //2、operationQueue是并行运行的，不能设置串行。但是可以通过设置依赖来实现串行
    //3、一个独立的operation是同步运行的，如果想异步运行，必须将operation加入到一个operationQueue中。
    
    func operation_create() {
        //operation是一个不能直接使用的抽象类，在实际运用中只能使用operation的子类。
        //第一个子类blockOperation：对dispatchQueue.global()的一个封装，他可以管理一个或多个blocks。
        //引用blog的知识：bocks异步,并行的执行, 如果你想串行的执行任务, 你可以设置依赖或选择Custom queues(参见DispatchQueue).BlockOperation为一些已经使用了OperationQueue但不想使用DispatchQueue的App, 提供一种面向对象的封装. 作为一种Operation, 相比DisptachQueue, 它提供了更多的特性例如添加依赖, KVO通知, 取消任务等. 某种程度上BlockOperation也像一个一个DispatchGroup: 所有的blocks完成后它会收到通知.
        //第二个子类使用自定义的operation
        let blockOperation = BlockOperation()
        for i in 0..<10 {
            blockOperation.addExecutionBlock {
                sleep(2)
            }
        }
        blockOperation.completionBlock = {
            print("opertation执行完毕")
        }
        blockOperation.start()
    }
    
    /// operationQueue：operationQueue负责对operation进行调度，加入operationQueue后离职启动执行，无需手动start，通过maxConcurrentOperationCount设置并发任务量。
    func operationQueue_create() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.addOperation {
            print("operation1")
            sleep(2)
        }
        queue.addOperation {
            print("operation2")
            sleep(2)
        }
        queue.addOperation {
            print("operation3")
            sleep(2)
        }
    }
    //如果我们想要暂停和恢复执行 operation queue 中的 operation ，可以通过调用 operation queue 的 setSuspended: 方法来实现这个目的。不过需要注意的是，暂停执行 operation queue 并不能使正在执行的 operation 暂停执行，而只是简单地暂停调度新的 operation 。另外，我们并不能单独地暂停执行一个 operation ，除非直接 cancel 掉。
}
