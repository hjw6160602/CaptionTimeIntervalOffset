//
//  main.swift
//  字幕时间偏移
//
//  Created by SaiDiCaprio on 2020/9/8.
//  Copyright © 2020 SaiDiCaprio. All rights reserved.
//

import Foundation

let path = "/Users/saidicaprio/Downloads/caption.txt"
readFile(path: path, offset: -20)


func readFile(path:String, offset:TimeInterval) {
//  let fileManager = FileManager.default
    
//  guard let exist = fileManager.fileExists(atPath: path) else { return }
//  guard let fData = fileManager.contents(atPath: path) else { return }
//  let originalString = String.init(data: fData ?? Data.init(), encoding: String.Encoding.utf8)
//  let originString = String.init(data: fData, encoding: .utf8)
    
    if let streamReader = StreamReader(path: path) {
        defer {
            streamReader.close()
        }
        var outputString = ""
        while let line = streamReader.nextLine() {
            let separator = " --> "
            if line.contains(separator) {
                var newLine = ""
                let timeComponents = line.components(separatedBy: separator)
                var index = 0
//                print(line)
                for timeComponent in timeComponents {
                    let timeDebris = timeComponent.components(separatedBy: ",")
                    let timeString = "2020-09-04 " + timeDebris.first!
                    var realTime = stringConvertDate(string: timeString)
                    
//                    print(realTime)
                    realTime += offset;
//                    print(realTime)
                    let finalTime = dateConvertString(date: realTime)
//                    print(finalTime)
                    
                    newLine += finalTime
                    newLine += ","
                    newLine += timeDebris.last!
                    if index == 0 {
                        newLine += separator
                    }
                    index += 1
                }
//                print(newLine)
//                line = newLine
                outputString += (newLine + "\n")
            } else {
                outputString += (line + "\n")
            }
        }
        print(outputString)
        print("outputString")
    }
}

func stringConvertDate(string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
    let dateFormatter = DateFormatter()
//    dateFormatter.locale = Locale.init(identifier: "zh_CN")
    dateFormatter.dateFormat = dateFormat
    var date = dateFormatter.date(from: string)!
    //解决 Date date时间与实际相差8个小时解决方案
    let interval = NSTimeZone.system.secondsFromGMT(for: date)
    date += TimeInterval(interval)
    return date
}

func dateConvertString(date:Date, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> String {
     let timeZone = TimeZone.init(identifier: "UTC")
     let formatter = DateFormatter()
     formatter.timeZone = timeZone
//     formatter.locale = Locale.init(identifier: "zh_CN")
     formatter.dateFormat = dateFormat
     let date = formatter.string(from: date)
     return date.components(separatedBy: " ").last!
}

