//
//  WeatherViewController.swift
//  VirtualTourist
//
//  Created by Alhanouf Alawwad on 21/12/1442 AH.
//
import UIKit
import Foundation
class WeatherViewController :UIViewController {
    
    var pin:Pin!
    
    @IBOutlet weak var lacationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundView: UIView!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        lacationLabel.text = ""
        imageView.image = nil
        temperatureLabel.text = ""
        descriptionLabel.text = ""
        
        setBlueGradientBackground()
        getWeatherInfo()
    }
    func getWeatherInfo(){
        activityIndicator.startAnimating()
        
        OpenWeatherClient.getWeatherInfo(latitude:pin.latitude,longitude: pin.longitude){ (temp ,icon ,location,description ,error) in
            if error == nil {
                //Temperature
                guard temp == temp else {
                    return
                }
                self.temperatureLabel.text = "\(Double(round(1000*(temp! - 273.15)/1000))) ℃"
                //Icon
                guard icon == icon else {
                    return
                }
                let suffix = icon?.suffix(1)
                if(suffix == "n"){
                    //Night Icon
                    self.setGreyGradientBackground()
                }else{
                    //Day Icon
                    self.setBlueGradientBackground()
                }
                let url = URL(string: "https://openweathermap.org/img/wn/\(icon!)@2x.png")
                let imageData = try? Data(contentsOf: url!)
                self.imageView.image = UIImage(data: imageData!)
                
                //Location
                guard let location =  location else{
                    return
                }
                self.lacationLabel.text = location
                
                //Weather description
                guard description == description else{
                    return
                }
                self.descriptionLabel.text = description
            }
            else{
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
}







