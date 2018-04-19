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
    
    /// 创建custom queue：默认为串行队列，但是如果指定了attributes为concurrent，则变为并行队列
    func DispatchQueue_CustomQueue() {
        //创建串行队列
        DispatchQueue(label: "com.queue").async {
            print("customQueue的串行队列")
        }
        
        //创建并行队列
        let queue = DispatchQueue(label: "com.queue", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        queue.async {
            print("customQueue的并行队列")
        }
        //默认创建的时候，可以使用  DispatchQueue(label: "com.queue", attributes: DispatchQueue.Attributes.concurrent),上边的方法为完整的传参方法创建
        
        //其中，autoreleaseFrequency：顾名思义，自动释放频率。有些队列是会在履行完任务后自动释放的，有些比如Timer等是不会自动释放的，是需要手动释放。
        //以前，DispatchQueues将在未指定的时间（当线程变为不活动时）弹出它们的自动释放池。 在实践中，这意味着您为每个提交的调度项目创建了一个自动释放池，或者您的自动释放的对象将挂起不可预测的时间量。
        //非确定性不是什么好事情（特别是在并发库！），所以现在Apple允许你指定三种行为之一：
        //.inherit：不确定，之前默认的行为也是现在的默认值
        //.workItem：为每个执行的项目创建和排除自动释放池,项目完成时清理临时对象
        //.never：GCD不为您管理自动释放池
    }
}

// MARK: - 创建barrier
extension GCD_Swift
{
    func dispatch_barrier() {
        //创建barrier
        let barrier = DispatchWorkItem(flags: DispatchWorkItemFlags.barrier) {
            sleep(3)
            print("barrier执行")
        }
        DispatchQueue(label: "com.artron.queue", attributes: .concurrent).async(execute: barrier)
        
        //barrier：用于等待前面的任务执行完毕后自己才执行，而barrier之后的任务需等待它执行完成之后才执行。
        //典型例子：数据的读写，通常为了防止文件读写导致冲突，我们会创建一个串行队列，所有的读取文件都在串行队列里来执行。
        //FMDB：众所周知，FMDB是一个并行操作，但是它是怎么保证写入的时候是串行执行，读取的时候是并行执行呢？
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        queue.async {
            print("reading 1")
        }
        queue.async(execute: barrier)
        queue.async {
            sleep(2)
            print("reading 2")
        }
        queue.async {
            print("reading 3")
        }
        print("执行完毕")
        //输出结果为：
        //执行完毕
        //reading 1
        //barrier执行
        //reading 3
        //reading 2
        //从上可以看出，barrier的执行sleep了3秒，这是一个并行队列，而reading2和reading3都在barrier之后执行，所以验证了上边的论证。
    }
}

// MARK: - dispatchGroup：用来追踪不同队列的不同任务，当group里所有的事件都完成后，有两种方式可以返回通知：1、wait，会阻塞当前线程  2、notify：block执行任务，不阻塞当前线程
extension GCD_Swift
{
    func dispatch_Group() {
        let numberArray = [("A","a"),("B","b"),("2","3")]
        let group = DispatchGroup()
        for invalue in numberArray {
            DispatchQueue.global().async(group: group) {
                sleep(3)
                print("invalue=\(invalue.0)")
            }
        }
        /*
        group.wait()    //阻塞当前线程，group里的GCD不完成不调用后续代码
        print("执行完成")
        */
        group.notify(queue: DispatchQueue.main) {
            print("执行完成所有DCG任务，返回主线程")
        }
        print("调用完成")
        
        //输出为：
        //调用完成
        //invalue=A
        //invalue=2
        //invalue=B
        //执行完成所有DCG任务，返回主线程
    }
}

// MARK: - 信号量的使用：控制线程最大的并发数，通常先wait()然后再signal()，wait会将信号量-1，singal会将信号量+1。
extension GCD_Swift
{
    func dispatch_semaphore() {
        //创建信号量，默认最大并打线程数为2个
        let semaphore = DispatchSemaphore(value: 2)
        let queue = DispatchQueue(label: "queue", attributes: .concurrent)
        queue.async {
            semaphore.wait()
            print("reading 1-start")
            sleep(2)
            print("reading 1-end")
            semaphore.signal()
        }
        queue.async {
            semaphore.wait()
            print("reading 2-start")
            sleep(2)
            print("reading 2-end")
            semaphore.signal()
        }
        queue.async {
            semaphore.wait()
            print("reading 3-start")
            sleep(2)
            print("reading 3-end")
            semaphore.signal()
        }
        print("执行完毕")
        //输出结果为：
        //执行完毕
        //reading 1-start
        //reading 2-start
        //reading 2-end
        //reading 1-end
        //reading 3-start
        //reading 3-end
        
        //如果信号量初始化为1的时候，输出结果为：
        //执行完毕
        //reading 1-start
        //reading 1-end
        //reading 2-start
        //reading 2-end
        //reading 3-start
        //reading 3-end
    }
}

extension GCD_Swift
{
    //如题：有10个线程，如何获取到10个线程处理完成的通知？
    //1、使用group，创建一个GCDGroup，开启10个并发线程，然后将10个线程放入group中，使用wait(阻塞当前线程)或者notify(不阻塞当前线程)触发处理。
    //2、使用barrier，创建10个并发线程，然后再10个并发线程后创建barrier线程，这样就保证了barrier之前的线程处理完成后才能处理barrier
    //3、使用信号量，则创建11个线程，开辟初始化信号量为10，这样就会有10个并发线程，10个线程处理完成后，才会调用最后一个线程，这样间接的完成了10个线程处理完成的通知行为。
    //4、创建10个串行的异步队列，这样就会一个一个的下载
}


