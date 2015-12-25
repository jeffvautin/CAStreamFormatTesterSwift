//
//  main.swift
//  CAStreamFormatTesterSwift
//
//  Created by Jeff Vautin on 12/25/15.
//  Copyright © 2015 Jeff Vautin. All rights reserved.
//

import Foundation
import AudioToolbox

var fileTypeAndFormat = AudioFileTypeAndFormatID(mFileType: kAudioFileAIFFType, mFormatID: kAudioFormatLinearPCM)
var audioErr = noErr
var infoSize: UInt32 = 0

audioErr = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, UInt32(sizeof(AudioFileTypeAndFormatID)), &fileTypeAndFormat, &infoSize)
assert(audioErr == noErr)

var asbds = UnsafeMutablePointer<AudioStreamBasicDescription>.alloc(Int(infoSize))
audioErr = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat, UInt32(sizeof(AudioFileTypeAndFormatID)), &fileTypeAndFormat, &infoSize,asbds)
assert(audioErr == noErr)

let asbdCount = Int(infoSize) / sizeof(AudioStreamBasicDescription)
for i in 0 ..< asbdCount {
    var format4cc: UInt32 = asbds[i].mFormatID.bigEndian
    withUnsafePointer(&format4cc) { format4ccPtr in
        print(String(format: "%d: mFormatID: %4.4s, mFormatFlags: %d, mBitsPerChannel: %d", arguments: [i,format4ccPtr,asbds[i].mFormatFlags,asbds[i].mBitsPerChannel]))    }
}