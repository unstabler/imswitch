//
//  main.swift
//  imswitch
//
//  Created by Gyuhwan Park on 2020/06/19.
//  Copyright © 2020 Gyuhwan Park. All rights reserved.
//

import Foundation
import Carbon

func enumerateInputSourceList() -> [TISInputSource] {
    let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
    let inputSourceList = inputSourceNSArray as! [TISInputSource]

    return inputSourceList
}

func getIdOfInputSource(_ inputSource: TISInputSource) -> String {
    return unsafeBitCast(TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID), to: CFString.self) as String
}

func getNameOfInputSource(_ inputSource: TISInputSource) -> String {
    return unsafeBitCast(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName), to: CFString.self) as String
}

func setInputSource(_ inputSourceId: String) {
    let filteredSources = enumerateInputSourceList().filter({
        (inputSource: TISInputSource) -> Bool in
        return getIdOfInputSource(inputSource) == inputSourceId
    })
    
    if (filteredSources.count > 0) {
        let inputSource = filteredSources[0]
        print("switching to \(getNameOfInputSource(inputSource))")
        TISSelectInputSource(inputSource)
    }
}

let args = CommandLine.arguments

if (args.contains("-l")) {
    let inputSourceList = enumerateInputSourceList()
    for inputSource in inputSourceList {
        let id = getIdOfInputSource(inputSource)
        let name = getNameOfInputSource(inputSource)
        
        print("\(id)\t\(name)")
    }
} else if (args.count > 1) {
    let inputSourceId = args[1]
    setInputSource(inputSourceId)
} else {
    print("imswitch [-l] [input source id]")
}



