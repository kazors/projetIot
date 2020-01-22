//
//  ViewController.swift
//  projetIOS
//
//  Created by etudiant on 21/01/2020.
//  Copyright © 2020 etudiant. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import Crashlytics

class ViewController: UIViewController {
    var listPokemon : [Result]=[]
    
    var window: UIWindow?

    @IBOutlet weak var pokemontableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
        AnalyticsParameterContentType: "text",
        AnalyticsParameterItemID: "LA LISTE"
        ])
        let url = "https://pokeapi.co/api/v2/pokemon/"

        //FirebaseApp.configure()
        let db = Firestore.firestore()
        //on charge la base firestore avec des data
        AF.request(url).responseDecodable{ (reponse :DataResponse<Pokemon, AFError>) in
            switch reponse.result{
            case .success (let pokemons) :
                for result in pokemons.results {
                    db.collection("pokemon").getDocuments(){
                        (querysnapshot , err) in
                        if let err=err{
                            print("error")
                        }else{
                            if querysnapshot?.count ?? 0==0{
                                db.collection("pokemon").addDocument(data: [
                                    "name":result.name,
                                    "url":result.url
                                ]) {err in
                                    if let err=err {
                                        print("error addind document")
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                }
                
                break
            case .failure (let error):
                print(error)
            }
        }
        
        
        //on charge les données car on est content
        db.collection("pokemon").getDocuments(){
            (querysnapshot , err) in
            if let err=err {
                print("error")
            }else{
                for element in querysnapshot!.documents{
                    self.listPokemon.append(Result(name: element.get("name") as! String, url: element.get("url") as! String))
                }
                self.pokemontableView.reloadData()
            }
            
        }
        
        pokemontableView.rowHeight=UITableView.automaticDimension
        pokemontableView.estimatedRowHeight=80
        pokemontableView.delegate=self
        pokemontableView.dataSource=self
        let button = UIButton(type: .roundedRect)
         button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
         button.setTitle("Crash", for: [])
         button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
         view.addSubview(button)
    }
    
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
 
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pokemontableView.reloadData()
    }


}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCellIdentifier", for: indexPath) as? PokemoncellTableViewCell{
            let result=listPokemon[indexPath.row]
            cell.fill(pokemon: result)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let poke = listPokemon[indexPath.row]

        Analytics.logEvent(AnalyticsEventShare, parameters: [
        AnalyticsParameterContentType: "text",
        AnalyticsParameterItemID: poke.name
        ])
    }

    
}

