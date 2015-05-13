//
//  LoginViewController.swift
//  weixin
//
//  Created by housl on 15/4/28.
//  Copyright (c) 2015年 housl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var serverTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var autologinSwitch: UISwitch!
    
    var requireLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if sender as! NSObject == self.doneButton{
            
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "wxserver")
            NSUserDefaults.standardUserDefaults().setBool(autologinSwitch.on, forKey: "wxautologin")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            requireLogin = true
        }
    }

}





































