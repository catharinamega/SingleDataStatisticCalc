//
//  ViewController.swift
//  NanoChallenge1_Catharina
//
//  Created by Catharina Adinda Mega Cahyani on 30/04/22.
//

import UIKit
import SigmaSwiftStatistics
import StatKit

class ViewController: UIViewController {

   
    @IBOutlet weak var dataField: UITextField!
    
    @IBOutlet weak var outputTextView: UITextView!
    
    @IBOutlet weak var outputTableView: UITableView!
    
    let key: [String] = ["Count","Sum","Mean",
                         "Median",
                         "Mode",
                         "Largest","Smallest","Range","Geometric Mean","Sample Standard Deviation", "Sample Variance"]
    
    var value: [Double] = []
    
    
    var dataDict:[String:[Double]] = ["Count":[Double](),
                                      "Sum":[Double](),
                                      "Mean":[Double](),
                                      "Median":[Double](),
                                      "Mode":[Double](),
                                      "Largest":[Double](),
                                      "Smallest":[Double](),
                                      "Range":[Double](),
                                      "Geometric Mean":[Double](),
                                      "Sample Standard Deviation":[Double](),
                                      "Sample Variance":[Double]()
                                      
    ]
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataField.delegate = self
        setTableView()
        
    }

    @IBAction func generateButton(_ sender: Any) {
        value.removeAll()
        dataDict.removeAll()
        
        let inputText = dataField.text!
        let inputArray = inputText.components(separatedBy: ",")
//        let line = 1
//        let size = line // 10
//        let newText = stride(from: 0, to: inputArray.count, by: line ).map {
//              Array(inputArray [$0 ..< Swift.min($0 + size , inputArray.count)])
//            }
//        print(inputArray)
        let inputNumber = inputArray.compactMap{Double($0)}
        print(inputNumber)
        
        let input_count = Double(inputNumber.count)
        value.append(input_count)
        dataDict["Count"] = [input_count]
        
        let input_sum = inputNumber.reduce(0, +)
        value.append(Double(input_sum))
        dataDict["Sum"] = [input_sum]
        
        let input_mean = input_sum / input_count
        value.append(Double(input_mean))
        dataDict["Mean"] = [input_mean]
        
        let input_median = median(data: inputNumber) ?? 0
        value.append(input_median)
        dataDict["Median"] = [input_median]
        outputTableView.reloadData()
        
        let input_mode = mode(data: inputNumber) ?? []
//        value.append(input_mode)
        dataDict["Mode"] = input_mode
        outputTableView.reloadData()

        
        let input_max = inputNumber.max()
        value.append(Double(input_max ?? 0))
        dataDict["Largest"] = [input_max!]
        
        let input_min = inputNumber.min()
        value.append(Double(input_min ?? 0))
        dataDict["Smallest"] = [input_min!]
        
        let input_range = Int(input_max ?? 0) - Int(input_min ?? 0)
        value.append(Double(input_range))
        dataDict["Range"] = [Double(input_range)]
        
        
    
        let input_gm = pow(inputNumber.reduce(1.0, *), 1.0 / Double(inputNumber.count))
        value.append(Double(input_gm))
        dataDict["Geometric Mean"] = [input_gm]
        
        let input_stdev = stdev(data: inputNumber) ?? 0
        value.append(input_stdev)
        dataDict["Sample Standard Deviation"] = [input_stdev]
        outputTableView.reloadData()
        
        let input_variance = variance(data: inputNumber) ?? 0
        value.append(input_variance)
        dataDict["Sample Variance"] = [input_variance]
        outputTableView.reloadData()
        
//        let outputText = inputArray.joined(separator: " ")
//        let outputText =
//        "Count: \(input_count)\nSum: \(input_sum)\nMode: \(String(describing: input_mode))\nLargest Number: \(String(describing: input_max!) )\nSmallest Number: \(input_min!)\nRange: \(input_range)"
//        outputTextView.text = outputText
    }
    

    
    func setTableView() {
        outputTableView.delegate = self
        outputTableView.dataSource = self
    }
    
//    func untuk hitung
    func stdev(data:[Double]) -> Double? {
       return Sigma.standardDeviationSample(data)
    }
    
    func median(data:[Double]) -> Double? {
        return Sigma.median(data)
    }
    
    func variance(data:[Double]) -> Double? {
        return Sigma.varianceSample(data)
    }
    
    func mode(data:[Double]) -> [Double]? {
    //        kalau tidak ada ganti "none"
    //        let input_mode = inputNumber.mostFrequent?.mostFrequent.first ?? 0
    //        let input_mode_max = Sigma.frequencies(inputNumber).max { $0.key < $1.key}?.key ?? 0
//            let input_mode_max = Sigma.frequencies(inputNumber).max { $0.value < $1.value}?.key ?? 0
//    //        print(inputNumber.mostFrequent)
//            let input_mode = mode(of: inputNumber, variable: \.self)
//            print(input_mode)
//    //        print(Sigma.frequencies(inputNumber).max { $0.value < $1.value}?.key)
//            let tempInputMode = Array(input_mode)
//
//            value.append(tempInputMode[0])
//
//            let input_mode = mode(data: inputNumber) ?? 0
//            value.append(input_mode)
//            outputTableView.reloadData()
        
        var input_mode = data.mostFrequent?.mostFrequent
        if data.mostFrequent?.count == 1 {
            input_mode = [0]
        }

        print(input_mode)
        
        return input_mode
    }
//    func mode(data:[Double]) -> Double? {
//
//    }
    
    func mostFrequent(array: [Int]) -> (mostFrequent: [Int], count: Int)? {
        var counts: [Int: Int] = [:]
            
        array.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let count = counts.max(by: {$0.value < $1.value})?.value {
            return (counts.compactMap { $0.value == count ? $0.key : nil }, count)
        }
        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dataField.resignFirstResponder()
    }
    
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
    var mostFrequent: (mostFrequent: [Element], count: Int)? {
        guard let maxCount = frequency.values.max() else { return nil }
        return (frequency.compactMap { $0.value == maxCount ? $0.key : nil }, maxCount)
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        pakai value biar ga force close
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "outputTVC") as! outputTableViewCell
        cell.keyLabel.text = key[indexPath.row]
        
//        cell.keyLabel.text = Array(dataDict.values).key[indexPath.row]
//        cell.valueLabel.text = String(value[indexPath.row])
        let all_value = dataDict[key[indexPath.row]] ?? []
        
        var d = ""
        
        for i in all_value{
            if d == ""{
                d = String(i)
            }else{
                d = d + " | " + String(i)
            }
           
        }
//        print(all_value[0])
        
        cell.valueLabel.text = d
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        
        
        
        return cell
    }
    
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

