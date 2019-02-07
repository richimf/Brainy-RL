//
//  ViewController.swift
//  Hello
//
//  Created by Ricardo Montesinos Fernandez on 12/5/18.
//  Copyright © 2018 CubitStudio. All rights reserved.
//

import UIKit
import BrainyRL

class ViewController: UIViewController {

  let brain: Brainy = Brainy()

  override func viewDidLoad() {
    super.viewDidLoad()
    brain.setup()
    brain.environment
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

