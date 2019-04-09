//
//  DetailViewController.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 08/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelExp: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelTsCatched: UILabel!
    
    var pokemonResponse : PokemonResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(pokemonResponse != nil){
            labelName.text = pokemonResponse!.name
            labelWeight.text = String(pokemonResponse!.height)
            labelHeight.text = String(pokemonResponse!.height)
            labelExp.text = String(pokemonResponse.baseExperience)
            
            var types : String = ""
            for type in pokemonResponse.types{
                types += type.type.name+" "
            }
            labelType.text = types
            labelTsCatched.text = pokemonResponse.tsCatched!.description
            image.imageFromServerURL(pokemonResponse!.sprites.frontDefault!, placeHolder: nil)
        }else{
            print("DETAIL VIEW IS NILLL POKEMON FUCK")
        }
        // Do any additional setup after loading the view.
    }
    
    

}
