//
//  AlarmDetailTableViewController.swift
//  AlarmiOS27
//
//  Created by Austin West on 6/17/19.
//  Copyright © 2019 Austin West. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
          //  self.updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var alarmEnabledButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateViews() {
        
        guard let alarm = alarm else { return }
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        titleTextField.text = alarm.name
        setUpAlarmButton()
    }

    func setUpAlarmButton() {
        
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleEnabled(for: alarm)
            alarmIsOn = alarm.enabled
        } else {
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text else { return }
        guard title != "" else { return }
        
        if let alarm = alarm {
            AlarmController.sharedInstance.update(alarm: alarm, fireDate: datePicker.date, name: title, enabled: alarmIsOn )
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: datePicker.date, name: title, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
