//
//  ChatViewController.swift
//  weixin
//
//  Created by housl on 15/4/28.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController ,XxDL{

    
    @IBOutlet weak var msgTF: UITextField!
    //发送按钮
    
    @IBAction func composing(sender: UITextField) {
        
        var xmlmessage : DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        xmlmessage.addAttributeWithName("to", stringValue: toBuddyName)
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        xmlmessage.addAttributeWithName("from", stringValue: myID)
        
        var composing = DDXMLElement.elementWithName("composing") as! DDXMLElement
        
        composing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        xmlmessage.addChild(composing)
        zdl().xs!.sendElement(xmlmessage)
        
    }
    @IBAction func send(sender: UIBarButtonItem) {
        
        let msgStr = msgTF.text
        
        if(!msgStr.isEmpty){
            var xmlmessage : DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
        
            xmlmessage.addAttributeWithName("type", stringValue: "chat")
            xmlmessage.addAttributeWithName("to", stringValue: toBuddyName)
            let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
            xmlmessage.addAttributeWithName("from", stringValue: myID)
            
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(msgStr)
            
            xmlmessage.addChild(body)
            zdl().xs!.sendElement(xmlmessage)
            
            msgTF.text = ""
            
            var msg = WXMessage()
            msg.isMe = true
            msg.body = msgStr
            
            msgList.append(msg)
            
            self.tableView.reloadData()
        }
        
    }
    var toBuddyName = ""
    
    var msgList = [WXMessage]()
    
    //XxDL-delegate
    func newMsg(aMsg:WXMessage){
        
        if(aMsg.isComposing){
        
            self.navigationItem.title = "对方正在输入..."
        }else if(aMsg.body != ""){
            self.navigationItem.title = toBuddyName
            msgList.append(aMsg)
            self.tableView.reloadData()
        }        
    }
    
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        zdl().xxdl = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return msgList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        let msg = msgList[indexPath.row]
        
        cell.textLabel?.text = msg.body
        
        if (msg.isMe){
            cell.textLabel?.textAlignment = NSTextAlignment.Right
            cell.textLabel?.textColor = UIColor.grayColor()
        
        }else{
            cell.textLabel?.textAlignment = NSTextAlignment.Left
            cell.textLabel?.textColor = UIColor.orangeColor()
        }
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
