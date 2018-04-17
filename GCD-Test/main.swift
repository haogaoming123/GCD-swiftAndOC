//
//  main.swift
//  GCD-Test
//
//  Created by 宝宝 on 2018/4/17.
//  Copyright © 2018年 宝宝. All rights reserved.
//

import Foundation

DispatchQueue.global(qos: .userInitiated).async {
    print("userInitiated")
    sleep(2)
    DispatchQueue.main.async {
        print("main queue")
    }
}
DispatchQueue.global().async {
    print("default global queue")
}

