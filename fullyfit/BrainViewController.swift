//
//  BrainViewController.swift
//  fullyfit
//
//  Created by Charlie Luo on 9/9/18.
//

import UIKit
import Charts
import CoreBluetooth

class BrainViewController: UIViewController, CBCentralManagerDelegate, IXNMuseListener, IXNMuseConnectionListener, IXNMuseDataListener {
    
    @IBOutlet weak var chart: LineChartView!
    
    var data:[[Double]] = []
    
    @IBOutlet weak var blinkingLabel: UILabel!
    
    private var manager:IXNMuseManagerIos!
    private var muse:IXNMuse!
    private var logLines:NSMutableArray!
    private var btManager:CBCentralManager!
    private var btState:Bool = false
    private var lastBlink:Bool = false
    
    func assignbackground(){
        let background = UIImage(named: "BrainActivity.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        if (self.manager == nil) {
            self.manager = IXNMuseManagerIos.sharedManager()
        }
        self.manager.museListener = self
        assignbackground()
        blinkingLabel.isHidden = true

    }

    
    func updateGraph() {
        
        let data = LineChartData() //This is the object that will be added to the chart

        
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0...(self.data.count - 3) {
            let value = ChartDataEntry(x: Double(i), y: self.data[i][0]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "IXNEegEEG1") //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawValuesEnabled = false
        line1.colors = [NSUIColor.lightGray] //Sets the colour to blue
        line1.circleRadius = 5
        line1.circleColors = [NSUIColor.lightGray]
        line1.label = ""
        
        data.addDataSet(line1) //Adds the line to the dataSet

        
        lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0...(self.data.count - 3) {
            let value = ChartDataEntry(x: Double(i), y: self.data[i][1]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line2 = LineChartDataSet(values: lineChartEntry, label: "IXNEegEEG2") //Here we convert lineChartEntry to a LineChartDataSet
        line2.drawValuesEnabled = false
        line2.colors = [NSUIColor.orange] //Sets the colour to blue
        line2.circleRadius = 5
        line2.circleColors = [NSUIColor.orange]
        line2.label = ""
        
        data.addDataSet(line2) //Adds the line to the dataSet
        
        
        lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0...(self.data.count - 3) {
            let value = ChartDataEntry(x: Double(i), y: self.data[i][2]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line3 = LineChartDataSet(values: lineChartEntry, label: "IXNEegEEG3") //Here we convert lineChartEntry to a LineChartDataSet
        line3.drawValuesEnabled = false
        line3.colors = [NSUIColor.yellow] //Sets the colour to blue
        line3.circleRadius = 5
        line3.circleColors = [NSUIColor.yellow]
        line3.label = ""
        
        data.addDataSet(line3) //Adds the line to the dataSet
        
        
        lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        //here is the for loop
        for i in 0...(self.data.count - 3) {
            let value = ChartDataEntry(x: Double(i), y: self.data[i][3]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line4 = LineChartDataSet(values: lineChartEntry, label: "IXNEegEEG4") //Here we convert lineChartEntry to a LineChartDataSet
        line4.drawValuesEnabled = false
        line4.colors = [NSUIColor.gray] //Sets the colour to blue
        line4.circleRadius = 5
        line4.circleColors = [NSUIColor.gray]
        line4.label = ""
        
        data.addDataSet(line4) //Adds the line to the dataSet
        
        
        
        chart.data = data //finally - it adds the chart data to the chart and causes an update
        chart.xAxis.gridColor = UIColor.white
        chart.leftAxis.gridColor = UIColor.white
        chart.borderColor = UIColor.white
        
        chart.legend.enabled = true
        
        chart.xAxis.axisMinimum = Double(0)
        chart.xAxis.axisMaximum = Double(10)
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chart.xAxis.labelTextColor = UIColor.white
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.leftAxis.labelTextColor = UIColor.white
        chart.leftAxis.drawGridLinesEnabled = false
        chart.chartDescription?.text = ""
        chart.drawBordersEnabled = false
    }
    
    func museListChanged() {
        self.muse = self.manager.getMuses()[0]
        connect()
    }
    
    func receive(_ packet: IXNMuseConnectionPacket, muse: IXNMuse?) {
        var state:String!
        switch (packet.currentConnectionState) {
        case IXNConnectionState.disconnected:
            state = "disconnected"
            break
        case IXNConnectionState.connected:
            state = "connected"
            break
        case IXNConnectionState.connecting:
            state = "connecting"
            break
        case IXNConnectionState.needsUpdate: state = "needs update"; break
        case IXNConnectionState.unknown: state = "unknown"; break
        default: assert(false, "impossible connection state received")
        }
        print("connect: %@", state)
    }
    
    func receive(_ packet: IXNMuseDataPacket?, muse: IXNMuse?) {
        if packet?.packetType() == IXNMuseDataPacketType.alphaAbsolute ||
            packet?.packetType() == IXNMuseDataPacketType.eeg {
            if (packet!.values()[0].doubleValue < 200) {
                if (self.data.count > 15) {
                    self.data.remove(at: 0)
                    updateGraph()
                }
                var recieved:[Double] = []
                recieved.append(packet!.values()[0].doubleValue)
                recieved.append(packet!.values()[1].doubleValue)
                recieved.append(packet!.values()[2].doubleValue)
                recieved.append(packet!.values()[3].doubleValue)
                data.append(recieved)
                print(self.data)
            }
            
        }
        /*
 if packet.blink && packet.blink != self.lastBlink {
 self.log("blink detected")
 }
 self.lastBlink = packet.blink
 */
    }
    
    func receive(_ packet: IXNMuseArtifactPacket, muse: IXNMuse?) {
        if packet.blink && packet.blink != self.lastBlink {
            blinkingLabel.isHidden = false
        }
        else {
            blinkingLabel.isHidden = true
        }
        self.lastBlink = packet.blink
    }
    
    func connect() {
        self.muse.register(self)
        self.muse.register(self, type:IXNMuseDataPacketType.artifacts)
        self.muse.register(self, type:IXNMuseDataPacketType.alphaAbsolute)
        self.muse.register(self, type:IXNMuseDataPacketType.eeg)
        print("connected")

        self.muse.runAsynchronously()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.btState = (self.btManager.state == CBManagerState.poweredOn)
    }

    @IBAction func disconnect(sender:AnyObject!) {
        if (self.muse != nil) {self.muse.disconnect()}
    }

    @IBAction func scan(sender:AnyObject!) {
        self.manager.startListening()
    }

    @IBAction func stopScan(sender:AnyObject!) {
        self.manager.stopListening()
    }
    
    
}




