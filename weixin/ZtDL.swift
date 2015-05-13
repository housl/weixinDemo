//
//  ZtDL.swift
//  weixin
//
//  Created by housl on 15/4/29.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import Foundation

//状态代理协议
protocol ZtDL {

    func isOn(zt : Zhuangtai)
    func isOff(zt : Zhuangtai)
    func meOff()
    
}