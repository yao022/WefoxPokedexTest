//
//  SearchViewController.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    
    @IBOutlet weak var buttCatch: UIButton!
    var pokemonResponse : PokemonResponse!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(pokemonResponse != nil){
            labelName.text = pokemonResponse!.name
            labelWeight.text = String(pokemonResponse!.height)
            labelHeight.text = String(pokemonResponse!.height)

            image.imageFromServerURL(pokemonResponse!.sprites.frontDefault!, placeHolder: nil)
            
            if pokemonResponse.tsCatched != nil{
                buttCatch.isEnabled = false
            }
        }
        
       
        // Do any additional setup after loading the view.
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // IBACTIONS
    @IBAction func close(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func catchPokemon(sender: UIButton){
        let storyboard: UIStoryboard =
            UIStoryboard.init(name: "Main",bundle: nil);
       
        let backpsvController = storyboard.instantiateViewController(withIdentifier: "backpack") as! BackPackViewController
        pokemonResponse.tsCatched = Date()
        backpsvController.catchPokemon(pokemonResponse: pokemonResponse)
        dismiss(animated: true, completion: nil)
    }

}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
