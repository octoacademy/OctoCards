//
//  SettingsTableViewController.swift
//  Octo Cards
//
//  Created by Linda Ho on 6/8/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var reminderAllow: UISwitch!
    
    @IBAction func updateDate(_ sender: Any) {
        if datePicker.isHidden == true {
            datePicker.isHidden = false
        } else {
            datePicker.isHidden = true
        }
    }
    
    @IBAction func updateTimeLabel(_ sender: Any) {
        let reminderTimeString = DateFormatter.localizedString(from: userDefaultsReminderTime, dateStyle: .none, timeStyle: .short)
        
        if (reminderAllow.isOn == false) {
            dateButton.setTitle("None",for: UIControlState.normal)
        }
        else {
            dateButton.setTitle("\(reminderTimeString)",for: UIControlState.normal)
        }
    }
    
    var userDefaultsNotificationAllow = UserDefaults.standard.bool(forKey: "notificationsAllow")
    var userDefaultsReminderTime = UserDefaults.standard.object(forKey: "reminderTime") as! Date
    var userDefaultsInitiated = UserDefaults.standard.bool(forKey: "initialized")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reminderTimeString = DateFormatter.localizedString(from: userDefaultsReminderTime, dateStyle: .none, timeStyle: .short)
        
        datePicker.isHidden = true
        datePicker.date = userDefaultsReminderTime
        dateButton.setTitle("\(reminderTimeString)",for: UIControlState.normal)
        datePicker.addTarget(self, action: #selector(dateFormatter), for: UIControlEvents.valueChanged)
        
        if (userDefaultsNotificationAllow == true) {
            self.reminderAllow.isOn = true
        }
        else {
            self.reminderAllow.isOn = false
            dateButton.setTitle("None",for: UIControlState.normal)
        }
        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //DatePicker.addTarget(self, action: Selector(("dataPickerChanged:")), for: UIControlEvents.valueChanged)
        
       
     
    }
    
    func dateFormatter(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateButton.setTitle(dateFormatter.string(from: datePicker.date), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Close(_ sender: Any) {
        UserDefaults.standard.set(datePicker.date, forKey: "reminderTime")
        if (reminderAllow.isOn) {
            UserDefaults.standard.set(true, forKey: "notificationsAllow")
            self.scheduleLocalNotification()
        }
        else {
            UserDefaults.standard.set(false, forKey: "notificationsAllow")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func scheduleLocalNotification() {
        print("********** scheduleLocalNotificationcalled ************")
        let center = UNUserNotificationCenter.current()
        
        let reminderDateTime = UserDefaults.standard.object(forKey: "reminderTime") as! Date
        let calendar = Calendar.current
        let reminderHour = calendar.component(.hour, from: reminderDateTime)
        let reminderMinutes = calendar.component(.minute, from: reminderDateTime)
        
        print("reminder Time = \(reminderHour):\(reminderMinutes)")
        
        // Cancel any prior notifications
        center.removeAllPendingNotificationRequests()
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Octo Reminder"
        notificationContent.subtitle = "Remember to practice your words!"
        notificationContent.body = "Your most recent Octo word is XXXXX."
        
        // Add Trigger
        var dateComponents = DateComponents()
        dateComponents.hour = reminderHour
        dateComponents.minute = reminderMinutes
        //dateComponents.hour = 12
        //dateComponents.minute = 32
        
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "octo_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        center.add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}
