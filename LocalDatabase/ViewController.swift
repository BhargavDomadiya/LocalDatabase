//
//  ViewController.swift
//  LocalDatabase
//
//  Created by R93 on 08/02/35.
//

import UIKit
import FMDB


class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var arrEmployee: [Employee] = []
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        //Insert Meet
        if nameTextField.text?.count == 0 || addressTextField.text?.count == 0 || salaryTextField.text?.count == 0 {
            print("Please enter missing details")
            return
        }
        
        let query = "INSERT INTO emp (name, address, salary) VALUES ('\(nameTextField.text ?? "")', '\(addressTextField.text ?? "")', '\(salaryTextField.text ?? "")');"
        print(query)
        let databaseObject = FMDatabase(path: AppDelegate.databasePath)
        if databaseObject.open() {
            let result = databaseObject.executeUpdate(query, withArgumentsIn: [])
            if result == true {
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                messageLabel.text = "Data saved successfully"
            } else {
                messageLabel.text = "Data is not saved successfully"
            }
        }
        
    }
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        let query = "select * from emp"
        let databaseObject = FMDatabase(path: AppDelegate.databasePath)
        if databaseObject.open(){
            let results = databaseObject.executeQuery(query, withArgumentsIn: [])
            print(results)
            arrEmployee = []
            while results!.next() == true {
                let name = results?.string(forColumn: "name") ?? ""
                let address = results?.string(forColumn: "address") ?? ""
                let salary = results?.string(forColumn: "salary") ?? ""
                let employee = Employee(name: name, address: address, salary: salary)
                arrEmployee.append(employee)
            }
        print(arrEmployee)
            if arrEmployee.count > 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let employeeListViewController = storyBoard.instantiateViewController(withIdentifier: "EmployeeListViewController") as! EmployeeListViewController
                employeeListViewController.arrEmployee = arrEmployee
                navigationController?.pushViewController(employeeListViewController, animated: true)
            } else {
                print("No Data Found")
            }
        }
        
    }
    
    @IBAction func updateButtonClicked(_ sender: UIButton) {
        
        //Insert Meet
        if nameTextField.text?.count == 0 || addressTextField.text?.count == 0 || salaryTextField.text?.count == 0 {
            print("Please enter missing details")
            return
        }
        
        let query = "UPDATE emp SET address = '\(addressTextField.text ?? "")', salary = '\(salaryTextField.text ?? "")' WHERE name = '\(nameTextField.text ?? "")';"
        print(query)
        let databaseObject = FMDatabase(path: AppDelegate.databasePath)
        if databaseObject.open() {
            let result = databaseObject.executeUpdate(query, withArgumentsIn: [])
            if result == true {
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                messageLabel.text = "Data updated successfully"
            } else {
                messageLabel.text = "Data is not updated successfully"
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
        //Insert Meet
        if nameTextField.text?.count == 0 {
            print("Please enter missing details")
            return
        }
        
        let query = "DELETE FROM emp WHERE name = '\(nameTextField.text ?? "")';"
//        let query = "DELETE FROM emp WHERE name = '\(nameTextField.text ?? "")' AND salary = '\(salaryTextField.text ?? "")' ;"
//        let query = "DELETE FROM emp WHERE salary = '\(salaryTextField.text ?? "")';"
//        let query = "DELETE FROM emp WHERE name = '\(nameTextField.text ?? "")';"
        
        let databaseObject = FMDatabase(path: AppDelegate.databasePath)
        if databaseObject.open() {
            let result = databaseObject.executeUpdate(query, withArgumentsIn: [])
            if result == true {
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                messageLabel.text = "Data deleted successfully"
            } else {
                messageLabel.text = "Data is not deleted successfully"
            }
        }
    }
    
}
struct Employee {
    var name: String
    var address: String
    var salary: String
}
