//
//  StartViewController.swift
//  gp3d
//
//  Created by Александр Лыков on 13.07.17.
//  Copyright © 2017 GP F. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var basketButton: UIButton!
    
    @IBOutlet weak var footballButton: UIButton!
    
    @IBOutlet weak var hockeyButton: UIButton!
    
    @IBOutlet weak var baseballButton: UIButton!
    
    @IBOutlet weak var appTitle: UILabel!
    private var buttons: [UIButton] {
        return [baseballButton,basketButton,footballButton,hockeyButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appTitle.text = "З🏀Ж"
    }
    
    override func viewDidLayoutSubviews() {
        for button in buttons {
            button.layer.cornerRadius = button.frame.width/2.0
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "basketballSegue":
                break //print("🏀")
            default:
                break //print("🌚")
            }
        }
    }
}
