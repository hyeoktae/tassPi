//
//  File.swift
//  
//
//  Created by hyeoktae kwon on 2021/06/21.
//

import Foundation

@discardableResult
func shell(command: String) -> Int32 {
  let task = Process()
  if #available(macOS 10.13, *) {
    task.executableURL = URL(string: "/usr/bin/env")
  } else {
    task.launchPath = "/usr/bin/env"
  }
  task.arguments = ["bash", "-c", command]
  if #available(macOS 10.13, *) {
    do {
      try task.run()
    } catch let err {
      print("err: ", err.localizedDescription)
    }
  } else {
    task.launch()
  }
  task.waitUntilExit()
  return task.terminationStatus
}

let fileManager = FileManager.default

// file:///home/pi/Documents
let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

if !fileManager.fileExists(atPath: documentURL.path) {
  do {
    try fileManager.createDirectory(atPath: documentURL.path, withIntermediateDirectories: true, attributes: nil)
  } catch {
    print("couldn't create document directory")
  }
}

let path = documentURL.appendingPathComponent("tassImg.jpg")

let state = shell(command: "raspistill -o \(path.path)")
print("state: ", state)

if state == 0 {
  do {
    let photo = try Data(contentsOf: path)
    print("success get a photo: \(photo.count)")
  } catch (let err) {
    print("err occured \(err.localizedDescription)")
  }
}

//raspistill -o /home/pi/Documents/tassImg.jpg



//if #available(macOS 10.15, *) {
//  let camera = CameraManager()
//  camera.startCapture()
//} else {
//  // Fallback on earlier versions
//  print("no Module")
//}




