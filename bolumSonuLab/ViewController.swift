//
//  ViewController.swift
//  bolumSonuLab
//
//  Created by Agit on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sbListe: UISearchBar!
    @IBOutlet weak var tvListe: UITableView!
    
    var tumListe : [Makale] = []
    var yuklenmisListe : [Makale] = []
    var tumFiltreliListe : [Makale] = []
    
    var sayfa = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        var m : Makale
        
        for i in 0..<105 {
            m = Makale(baslik: "Başlik \(i)", kisaAciklama: "kisa Aciklama \(i)", aciklama: "Aciklama \(i)")
            
            tumListe.append(m)
            
            if i < 20 {
                yuklenmisListe.append(m)
            }
        }
        tumFiltreliListe.append(contentsOf: tumListe)
        tvListe.reloadData()
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tabGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tabGesture)
        
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    


}

extension ViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yuklenmisListe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let satir = Bundle.main.loadNibNamed("TVC_Makale", owner: self, options: nil)?.first as! TVC_Makale
        satir.lblBaslik.text = yuklenmisListe[indexPath.row].Baslik
        satir.lblKisaAciklama.text = yuklenmisListe[indexPath.row].KisaAciklama
        
        
        
        
        return satir
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if((scrollView.contentOffset.y + scrollView.frame.size.height)) > (scrollView.contentSize.height * 0.9) {
            
            ElemanEkle()
        }
    }
    func ElemanEkle(){
        if (((sayfa + 1)*20) < tumFiltreliListe.count){
            for i in ((sayfa + 1)*20)..<((sayfa + 2)*20){
                if i < tumFiltreliListe.count {
                    yuklenmisListe.append(tumFiltreliListe[i])
                }
            }
            sayfa += 1
            tvListe.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sayfa = 0
        tumFiltreliListe = searchText.isEmpty ? tumListe : tumListe.filter({ 
            (makale : Makale)-> Bool in
            return makale.Baslik.range(of: searchText, options: .caseInsensitive) != nil || makale.KisaAciklama.range(of: searchText, options: .caseInsensitive) != nil
        })
        yuklenmisListe.removeAll()
        
        for i in 0..<tumFiltreliListe.count{
            if i < 20 {
                yuklenmisListe.append(tumFiltreliListe[i])
            }
        }
        tvListe.reloadData()
    }
    
    
        
}

