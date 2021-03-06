//
//  PingMessage.swift
//  BitcoinSwift
//
//  Created by James MacWhyte on 9/27/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import Foundation

/// The ping message is sent primarily to confirm that the TCP/IP connection is still valid. An
/// error in transmission is presumed to be a closed connection and the address is removed as a
/// current peer.
/// https://en.bitcoin.it/wiki/Protocol_specification#ping
public struct PingMessage: MessagePayload {

  public var nonce: UInt64

  public init(nonce: UInt64? = nil) {
    if let nonce = nonce {
      self.nonce = nonce
    } else {
      self.nonce = UInt64(arc4random()) | (UInt64(arc4random()) << 32)
    }
  }

  // MARK: - MessagePayload

  public var command: Message.Command {
    return Message.Command.Ping
  }

  public var data: NSData {
    var data = NSMutableData()
    data.appendUInt64(nonce)
    return data
  }

  public static func fromData(data: NSData) -> PingMessage? {
    if data.length == 0 {
      println("WARN: No data passed to PingMessage \(data)")
      return nil
    }
    let stream = NSInputStream(data: data)
    stream.open()
    let nonce = stream.readUInt64()
    if nonce == nil {
      println("WARN: Failed to parse nonce from PingMessage \(data)")
      return nil
    }
    if stream.hasBytesAvailable {
      println("WARN: Failed to parse PingMessage. Too much data \(data)")
      return nil
    }
    return PingMessage(nonce: nonce)
  }
}
