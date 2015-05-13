//
//  BuddyListTableViewController.swift
//  weixin
//
//  Created by housl on 15/4/28.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import UIKit

class BuddyListTableViewController: UITableViewController,ZtDL,XxDL {
    @IBOutlet weak var mystatus: UIBarButtonItem!
    //好友数组,作为表格数据源
    var unreadList = [WXMessage]();
    
    var ztList = [Zhuangtai]();
    
    var logged = false
    
    var currentBuddyName = ""
    
    @IBAction func log(sender: UIBarButtonItem) {
        
        if logged {
            
            logoff()
            sender.image = UIImage(named: "off")
            
        }else{
            
            login()
            sender.image = UIImage(named: "on")
        }
        
    }
    
    //================================
    //ZtDL-delegate
    func meOff(){
        self.logoff()
    }
    
    //上线状态处理
    func isOn(zt : Zhuangtai)
    {
        for(index, oldzt) in enumerate(ztList) {
            if(zt.name == oldzt.name){

//                ztList[index].isOnline = false
                
                ztList.removeAtIndex(index)
                break
            }
        }
        
        ztList.append(zt)
        self.tableView.reloadData()
    }
    
    func isOff(zt : Zhuangtai){
    
        for(index,oldzt) in enumerate(ztList){
            if(zt.name == oldzt.name){
//                oldzt.isOnline = false
                ztList[index].isOnline = false
            }
        }
        
        self.tableView.reloadData()
    }
    
    //================================
    //XxDL-delegate
    func newMsg(aMsg:WXMessage){
    
        if (aMsg.body != ""){
        
            unreadList.append(aMsg)
            self.tableView.reloadData()
        }
        
    }
    //===============================
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    
    }
    
    func login(){
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().connect()
        
        mystatus.image = UIImage(named: "on")
        logged = true
        
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        self.navigationItem.title = myID! + "的好友"
        self.tableView.reloadData()
    }
    
    func logoff(){
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().disConnect()
        mystatus.image = UIImage(named: "off")
        logged = false
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        let autologin = NSUserDefaults.standardUserDefaults().boolForKey("wxautologin")
        
        if(myID != nil && autologin){
            
            self.login()
            //            self.navigationItem.title = myID! + "的好友"
            
        }else{
            
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
        }
        

        zdl().ztdl = self
        
    }

    override func viewDidAppear(animated: Bool) {

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
        return ztList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as! UITableViewCell
        
        let online = ztList[indexPath.row].isOnline
        
        let name = ztList[indexPath.row].name
        
        //未读消息条数
        var unreads = 0
        
        //查找相应好友的未读条数
        for msg in unreadList{
            if ( name == msg.from ){
                unreads++
            }
        }
        
        
        cell.textLabel?.text = name + "(\(unreads))"
        
        if online{
            cell.imageView?.image = UIImage(named: "on")
        }else{
            cell.imageView?.image = UIImage(named: "off")
        }
        

        return cell
    }
    /**/

    //选择单元格
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //
        currentBuddyName = ztList[indexPath.row].name
        
        self.performSegueWithIdentifier("toChatSegue", sender:self)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
//        toChatSegue
        if (segue.identifier == "toChatSegue"){
            let dest = segue.destinationViewController as! ChatViewController
            
            dest.toBuddyName = currentBuddyName;
            
            //传递未读消息
            for msg in unreadList{
                if msg.from == currentBuddyName{
                 
                    dest.msgList.append(msg)
                    
                }
            }
            
//            removeValueFromArray(currentBuddyName, &unreadList)
            
            unreadList = unreadList.filter{
            
                $0.from != self.currentBuddyName
                
            }
            
            
            
            
            
            self.tableView.reloadData()
            
        }
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        //如果是完成
        
        let source = segue.sourceViewController as! LoginViewController
        if source.requireLogin {
            self.logoff()
            self.login()
        }
        
    }

}
