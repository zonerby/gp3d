//
//  MenuViewController.swift
//  gp3d
//
//  Created by Александр Лыков on 12.07.17.
//  Copyright © 2017 GP F. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var basketButton: UIButton!
    
    @IBOutlet weak var footballButton: UIButton!
    
    @IBOutlet weak var hockeyButton: UIButton!
    
    @IBOutlet weak var baseballButton: UIButton!
    
    @IBOutlet weak var apptitle: UILabel!
    
    @IBAction func basketButtonPressed(_ sender: UIButton) {
        print("я тутачки 🤡")
        performSegue(withIdentifier: "gameSegue", sender: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        apptitle.text = "Время кайфа"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gameSegue" {
            print("теперь тутачки 🌚")
        }
        
    }

}
