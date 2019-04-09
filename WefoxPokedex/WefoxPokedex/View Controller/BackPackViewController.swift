//
//  BackPackController.swift
//  WefoxPokedex
//
//  Created by Jordi Ferrer Pedrol on 07/04/2019.
//  Copyright © 2019 Jordi Ferrer Pedrol. All rights reserved.
//

import UIKit



class BackPackViewController: UICollectionViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var buttCatch: UIBarButtonItem!
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    
    var networkManager = NetworkManager()
    
    var backpack = PokemonResponse.backPack
    
    var currentPokemon : PokemonResponse?
    
    private let reuseIdentifier = "pokemonCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backpack = backpack.sorted(by: { $0.order > $1.order })
        //self.collectionView.delegate = self
        //self.collectionView!.register(PokemonCell.self, forCellWithReuseIdentifier: "pokemonCell")

        // Do any additional setup after loading the view.
        
        if(backpack.count == 0){
            let alert = UIAlertController(title: "Catch some Pokemons!", message: "You haven't catched any Pokemon yet, give a try and throw a Pokeball!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Throw!", style: .default, handler: { action in
                switch action.style{
                case .default:
                   self.doSearch(sender: nil)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loading.isHidden = true
        DispatchQueue.main.async {
            
            self.backpack = PokemonResponse.backPack
            self.collectionView!.reloadData()
            self.collectionView!.collectionViewLayout.invalidateLayout()
            self.collectionView!.layoutSubviews()
        }
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if(segue.identifier == "ShowDetail"){
                print("INSIDE SEGUEEEEEEEEEEEEEEEE")
                let selectedIndexPath = self.collectionView!.indexPathsForSelectedItems![0]
                let controller = segue.destination as! DetailViewController
                controller.pokemonResponse = self.backpack[selectedIndexPath.item]
            }
            // Get the new view controller using [segue destinationViewController].
            // Pass the selected object to the new view controller.
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return PokemonResponse.backPack.count
    }

    override func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! PokemonCell


        if(backpack.count == indexPath.item){
            backpack = PokemonResponse.backPack
        }
        let pokemon = backpack[indexPath.item]
       
        cell.backgroundColor = .white
        //3
        cell.image.imageFromServerURL(pokemon.sprites.frontDefault!, placeHolder: nil)
        cell.labelName.text = pokemon.name
        
        return cell
    }
  

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    func showApiErrorAlert(){
        let alert = UIAlertController(title: "Ups!", message: "There was some issue throwing the ball, please try it again!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func doSearch(sender: UIBarButtonItem?){
        print("GOING TO SEARCH A POKEMON !!! ")
        let id = Int.random(in: 1...1000)
        loading.isHidden = false
        loading.startAnimating()
        networkManager.getPokemon(id: id) { pokemonResponse, error in
            
            if(error != nil){
                print("API CALL ERROR \(String(describing: error))")
                self.showApiErrorAlert()
            }else{
                print("POKEMON CAPUTRED ! ")
                self.currentPokemon = pokemonResponse
         
                for pokemon in self.backpack{
                    if(self.currentPokemon!.id == pokemon.id){
                        self.currentPokemon?.tsCatched=pokemon.tsCatched
                        break
                    }
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
               
                controller.pokemonResponse = pokemonResponse
                self.present(controller, animated: true, completion: nil)
               
                
            }
            
        }
        self.loading.isHidden = true
    }
    
   
    
    @IBAction func refresh(sender: UIBarButtonItem){
        collectionView!.reloadData()
        collectionView!.collectionViewLayout.invalidateLayout()
        collectionView!.layoutSubviews()
    }
    
    func catchPokemon(pokemonResponse: PokemonResponse!){
        print("ADD POKEMON TO THE BACKPACK !!! \(backpack.count)")
        backpack.append(pokemonResponse)
        print("ADDed POKEMON TO THE BACKPACK !!! \(backpack.count)")
        PokemonResponse.saveBackpack(backpack: backpack)
        backpack = PokemonResponse.backPack
        
    }
    
    func printBackpack(){
        print("BACKPACK LISTING")
        for pokemon in backpack {
            print(pokemon.name)
        }
    }
}
// MARK: - Collection View Flow Layout Delegate
extension BackPackViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
