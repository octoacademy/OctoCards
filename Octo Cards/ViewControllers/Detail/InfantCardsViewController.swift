//
//  OctoDetailViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/19/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit
import AVFoundation

class InfantCardsViewController: UIViewController{

    var item : Item!
    var categoryKey = ""
    var subCategoryKey = ""
    var index = 0
    var totalCount = 0
    
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var backCardArea: UIView!
    @IBOutlet weak var cardArea: UIView!
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var scenarioText: UILabel!
    
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
     @IBOutlet weak var chineseTranslation: UILabel!
    @IBOutlet weak var englishPhrase: UILabel!
    
    @IBOutlet weak var directTranslation: UILabel!
    @IBOutlet weak var tips: UILabel!
    @IBOutlet weak var chineseText: UILabel!
    @IBOutlet weak var myOctoButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    
    @IBOutlet weak var remindMeLabel: UILabel!
    @IBOutlet weak var reminderPickerView: UIView!
    @IBOutlet weak var reminderAuthorizationView: UIView!
    @IBOutlet weak var goToSettingButton: UIButton!
    
    @IBOutlet weak var authorizeNotificationSwitch: UISwitch!
    weak var delegate : InfantCardsPageViewController!
    var pickerView: UIDatePicker = UIDatePicker()
    
    var alertView = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardArea.layer.cornerRadius = 10
        self.cardArea.clipsToBounds = true
        
        self.backCardArea.layer.cornerRadius = 10
        self.backCardArea.clipsToBounds = true
        
        /******** play audio ************/
        do {
            let audioPath = Bundle.main.path(forResource: "ChangingDiaper_washhands", ofType: "mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
        }
        audioPlayer.play()
        /*********************************/
        
        
        //setupPreviousNextScreen()
        
        scenarioText.adjustsFontSizeToFitWidth = true
        scenarioText.numberOfLines  = 0
         // Do any additional setup after loading the view.
        scenarioText.text = item.scenario
        chineseTranslation.text = item.phrase_py
        englishPhrase.text = item.phrase
        
        chineseText.text = item.phrase_trans
        
        directTranslation.adjustsFontSizeToFitWidth = true
        directTranslation.numberOfLines  = 0
        directTranslation.text = "Direct Translation : \(item.phrase ?? "")"
        
        tips.text = item.tip
        
        myOctoButton.isSelected = false
        gotItButton.isSelected = false
        
        let key = categoryKey + "||" + subCategoryKey + "||" + item.itemName!
        if let _ =  CategoryManager.sharedInstance.myOctoStrings.index(of: key)
        {
            myOctoButton.isSelected = true
        }
        
        if let _ =  CategoryManager.sharedInstance.gotItStrings.index(of: key)
        {
            gotItButton.isSelected = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAuthorizationToUseNSNotifications()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRoundedCorner()
    {
        self.cardArea.layer.cornerRadius = 10
        self.cardArea.clipsToBounds = true
        
        self.backCardArea.layer.cornerRadius = 10
        self.backCardArea.clipsToBounds = true
    }
    
    func setupPreviousNextScreen()
    {
        let img = rightButton.currentBackgroundImage!.withRenderingMode(.alwaysTemplate)
        rightButton.setBackgroundImage(img, for: UIControlState())
        rightButton.tintColor = UIColor(red: 195.0/255, green: 195.0/255, blue: 195.0/255, alpha: 1.0)
        
        let img2 = leftButton.currentBackgroundImage!.withRenderingMode(.alwaysTemplate)
        leftButton.setBackgroundImage(img2, for: UIControlState())
        leftButton.tintColor = UIColor(red: 195.0/255, green: 195.0/255, blue: 195.0/255, alpha: 1.0)
        rightButton.isHidden = index == totalCount - 1 ? true : false
        leftButton.isHidden =  index == 0 ? true : false
    }

    func setupPickerView()
    {
        let done = UIButton(frame: CGRect(x: self.view.bounds.width - 100, y: 0, width: 100, height: 50))
        done.setTitle("Done", for: .normal)
        done.setTitleColor(UIColor.darkGray, for: .normal)
        done.addTarget(self, action: #selector(pressDone(button:)), for: .touchUpInside)
        
        pickerView.datePickerMode = .time
        pickerView.backgroundColor = UIColor.clear
        pickerView.frame = CGRect(x: 0, y: 25, width: self.view.bounds.width - 20 , height: 200)
        
        alertView = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        alertView.isModalInPopover = true;
        alertView.view.addSubview(self.pickerView)
        alertView.view.addSubview(done)
        //alertView.view.backgroundColor = UIColor.white
        
        if let presenter = alertView.popoverPresentationController {
            presenter.permittedArrowDirections = .up
            presenter.sourceView = self.remindMeLabel
            presenter.sourceRect = self.remindMeLabel.bounds
            presenter.sourceRect.origin.y = presenter.sourceRect.origin.y + 10
            pickerView.frame.size.width = 200
        }
    }
    
    func setupAuthorizationToUseNSNotifications()
    {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus.rawValue == 0 //undetermined
            {
                self.authorizeNotificationSwitch.isOn = false
                self.reminderPickerView.isHidden = true
                self.goToSettingButton.isHidden =  true
            }
            else if settings.authorizationStatus.rawValue == 2//authorized
            {
                self.authorizeNotificationSwitch.isOn = true
                self.reminderPickerView.isHidden = false
                self.goToSettingButton.isHidden =  true
            }
            else
            {
                self.reminderPickerView.isHidden = true
                self.reminderAuthorizationView .isHidden = true
                self.goToSettingButton.isHidden =  false
            }
        }
    }
    
    func getPermissionFromUser()
    {
        // TODO : might want to show spinner as it take more than a sec for the requestAuthorization to complete
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                 self.authorizeNotificationSwitch.isOn = false
                self.reminderAuthorizationView.isHidden = true
                self.reminderPickerView.isHidden = true
                self.goToSettingButton.isHidden = false
            }
            else
            {
                self.reminderPickerView.isHidden = false
                self.goToSettingButton.isHidden = true
            }
            
        }
    }

    func tap(_ gesture: UITapGestureRecognizer)
    {
        alertView.dismiss(animated: true, completion: nil)
    }
    
    func pressDone(button: UIButton) {
        alertView.dismiss(animated: true, completion: nil)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let dateString = formatter.string(from: pickerView.date)
        self.remindMeLabel.text = dateString
    }
    
    @IBAction func addToMyOcto(_ sender: UIButton) {
       
          if myOctoButton.isSelected
        {
            myOctoButton.isSelected = false
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                        subCategory: subCategoryKey,
                                                        item: self.item.itemName!, type: .myOcto)
        }
        else
        {
            gotItButton.isSelected = false
            myOctoButton.isSelected = true
            
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                      subCategory: subCategoryKey,
                                                      item: self.item.itemName!, type: .gotIt)

            CategoryManager.sharedInstance.addItem(category: categoryKey,
                                                     subCategory: subCategoryKey,
                                                     item: self.item.itemName!, type: .myOcto)
        }

    }
    
    
    @IBAction func addToGotIt(_ sender: UIButton) {
        
        if gotItButton.isSelected
        {
            gotItButton.isSelected = false
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                        subCategory: subCategoryKey,
                                                        item: self.item.itemName!, type: .gotIt)
        }
        else
        {
            gotItButton.isSelected = true
            myOctoButton.isSelected = false
            
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                      subCategory: subCategoryKey,
                                                      item: self.item.itemName!, type: .myOcto)

            CategoryManager.sharedInstance.addItem(category: categoryKey,
                                                     subCategory: subCategoryKey,
                                                     item: self.item.itemName!, type: .gotIt)
        }

    }
    
    @IBAction func goScreen(_ sender: UIButton) {
        if sender.tag == 1 //right
        {
            self.delegate.moveNextPage(index)
        }
        else
        {
            self.delegate.movePreviousPage(index)
        }
    }
    
    @IBAction func flip(_ sender: UIButton) {
        
        
        if !cardArea.isHidden
        {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

            UIView.transition(with: cardArea, duration: 1.0, options: transitionOptions, animations: {
                self.cardArea.isHidden = true
            })
            UIView.transition(with: backCardArea, duration: 1.0, options: transitionOptions, animations: {
                self.backCardArea.isHidden = false
            })
        }
        else
        {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]

            UIView.transition(with: backCardArea, duration: 1.0, options: transitionOptions, animations: {
                self.backCardArea.isHidden = true
            })
            UIView.transition(with: cardArea, duration: 1.0, options: transitionOptions, animations: {
                self.cardArea.isHidden = false
            })

        }

    }
    
    @IBAction func remind(_ sender: Any) {
        present(alertView, animated: true, completion :{
            for v in (self.alertView.view.superview?.subviews)!
            {
                if !v.isUserInteractionEnabled
                {
                    v.isUserInteractionEnabled = true
                    v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
                    break
                }
            }
             })
    }
    
    @IBAction func changeNotification(_ sender: UISwitch) {
        
        if sender.isOn
        {
            getPermissionFromUser()
        }
        else
        {
            reminderPickerView.isHidden = true
            
            //TODO: Delete the notifications
        }
    }
    
    @IBAction func goToSettings(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
        
    }
}

