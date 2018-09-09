//
//  ViewController.swift
//  fullyfit
//
//  Created by Charlie Luo on 9/8/18.
//

import Foundation
import UIKit
import Charts
import FacebookCore
import FacebookLogin
import CSV

class ViewController: UIViewController {

    @IBOutlet weak var chart: LineChartView!
    var gl:CAGradientLayer!
    var data: [[String: Double]] = []
    
    var gradientLayer: CAGradientLayer!
    var imageView : UIImageView!
    
    var offset = 0
    let range = 7
    
    
    @IBOutlet weak var offsetLabel: UILabel!
    
    @IBAction func increaseOffset(_ sender: Any) {
        offset += 1
        offsetLabel.text! = String(offset)
        populateData()
        
    }
    
    @IBAction func decreaseOffset(_ sender: Any) {
        if (offset != 0) { offset -= 1 }
        offsetLabel.text! = String(offset)
        populateData()
    }
    
    
    func assignbackground(){
        let background = UIImage(named: "bg.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0...(self.data.count - 1) {
            let value = ChartDataEntry(x: self.data[i]["time"]!, y: self.data[i]["steps"]!) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Steps Taken") //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawValuesEnabled = false
        line1.colors = [NSUIColor.lightGray] //Sets the colour to blue
        line1.circleRadius = 5
        line1.label = ""
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chart.data = data //finally - it adds the chart data to the chart and causes an update
        chart.xAxis.gridColor = UIColor.white
        chart.leftAxis.gridColor = UIColor.white
        chart.borderColor = UIColor.white

        chart.legend.enabled = false

        chart.xAxis.axisMinimum = Double(offset)
        chart.xAxis.axisMaximum = Double(range + offset + 1)
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelTextColor = UIColor.white
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.leftAxis.axisMaximum = Double(27500)
        chart.leftAxis.labelTextColor = UIColor.white
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        let goalLimit = ChartLimitLine(limit: Double(10000), label: "Goal")
        chart.leftAxis.addLimitLine(goalLimit)
        chart.chartDescription?.text = ""

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //createGradientLayer()
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.magenta.cgColor, UIColor.purple.cgColor]
        gradientLayer.locations = [0.0, 0.4, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 1.0)
        gradientLayer.opacity = 0.7
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        offsetLabel.textColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        self.populateData()
        
        
    }
    
    func populateData() {
        self.data = []
        var text = ""
        let filePath = Bundle.main.url(forResource: "master_data", withExtension: "csv")
        do {
            text = try String(contentsOf: filePath!)
        }
        catch {
            text = ""
        }
        let csv = try! CSVReader(string: text)
        let header = csv.next()
        if (offset != 0) {
            for k in 0...(offset * 1440) {
                csv.next()
            }
        }
        for i in 0...(range + offset) {
            var sum = 0.0
            var row = csv.next()!
            let time = Double(row[0])!.truncatingRemainder(dividingBy: 1440.0)
            for j in 0...(1440 - 1) {
                row = csv.next()!
                sum += Double(row[2])!
            }
            data.append([
                "time" : time,
                "steps" : sum
                ])
        }
        
        updateGraph()
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

