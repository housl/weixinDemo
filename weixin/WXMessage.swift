//
//  WXMessage.swift
//  weixin
//
//  Created by housl on 15/4/28.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import Foundation

//好友消息结构
struct WXMessage{
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false
    

}

//状态结构
struct Zhuangtai {
    var name = ""
    var isOnline = false

}


func removeValueFromArray(aString:String, inout aList:[WXMessage]){
    
    var indexArray = [Int]()
    var returnArray = [Int]()
    
    for (index,value) in enumerate(aList) {
        if(aString == value.from){
            indexArray.append(index)
        }
    }
    
//    indexArray
//    returnArray
    
    for (index,value) in enumerate(indexArray) {
        returnArray.append(value-index)
    }
    
//    indexArray
//    returnArray
//    aList
    for (index,value) in enumerate(returnArray){
        
        aList.removeAtIndex(value)
        
    }
    
//    indexArray
//    returnArray

}