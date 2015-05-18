//
//  AppDelegate.swift
//  weixin
//
//  Created by housl on 15/4/28.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate {

    var window: UIWindow?
    
    //通道
    var xs:XMPPStream?
    //是否开启
    var isOpen = false
    //密码
    var pwd = ""
    
    var xxdl:XxDL?
    
    var ztdl: ZtDL?
    
    //建立通道
    func buildStream(){
        xs = XMPPStream();
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())

    }
    
    func goOnline(){
        var p = XMPPPresence()
        xs!.sendElement(p)
    }
    func goOffline(){
        var p = XMPPPresence(type: "unavailable")
        xs!.sendElement(p)
    }
    
    func connect() -> Bool{
        buildStream()
        
        if xs!.isConnected(){
            return true
        }
        
        let user = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        let password = NSUserDefaults.standardUserDefaults().stringForKey("weixinPwd")
        let server = NSUserDefaults.standardUserDefaults().stringForKey("wxserver")


        if (user != nil && password != nil) {
            //通道的用户名
            xs!.myJID = XMPPJID.jidWithString(user!)
            xs!.hostName = server
            
            pwd = password!
            xs!.connectWithTimeout(5000, error: nil)
            
        }
        
        
        return false;
    }
    
    func disConnect(){
        
        if xs != nil{
            if xs!.isConnected(){
            
                goOffline()
                xs!.disconnect()
            }
        }
        
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
//MARK: - XMPPStreamDelegate
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        
        println(message)
        
        if message.isChatMessage(){
            var msg = WXMessage()
            if message.elementForName("composing") != nil {
                
                msg.isComposing = true
                
            }
            
            //离线消息
            if message.elementForName("delay") != nil{
                msg.isDelay = true
                
            }
            
            //消息正文
            if let body = message.elementForName("body"){
                
                msg.body = body.stringValue()
            }
            
            msg.from = message.from().user + "@" + message.from().domain
            
            xxdl?.newMsg(msg)
        }
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let myUser = sender.myJID.user
        
        let user = presence.from().user
        
        let domain = presence.from().domain
        
        let pType = presence.type()
        if (user != myUser){
            
            var zt = Zhuangtai()
            zt.name = user + "@" + domain
            
            
            if pType == "available"{
                zt.isOnline = true
                
                ztdl?.isOn(zt)
            }else if pType == "unavailable"{
                ztdl?.isOff(zt)
            }
            
        }
        
    }
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        
        isOpen = true
        xs!.authenticateWithPassword(pwd, error:nil)
        
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //上线
        goOnline()
    }
}

