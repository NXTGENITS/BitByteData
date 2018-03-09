// Copyright (c) 2018 Timofey Solomko
// Licensed under MIT License
//
// See LICENSE for license information

import Foundation

/// A type that contains functions for reading `Data` byte-by-byte.
public class ByteReader {

    /// Size of the `data` (in bytes).
    public let size: Int

    /// Data which is being read.
    public let data: Data

    /// Offset to the byte in `data` which will be read next.
    public var offset: Int

    /**
     True, if `offset` points at any position after the last byte in `data`.

     - Note: It generally means that all bytes have been read.
     */

    public var isFinished: Bool {
        return self.data.endIndex <= self.offset
    }

    /// Creates an instance for reading bytes from `data`.
    public init(data: Data) {
        self.size = data.count
        self.data = data
        self.offset = data.startIndex
    }

    /**
     Reads byte and returns it, advancing by one position.

     - Precondition: There MUST be enough data left.
     */
    public func byte() -> UInt8 {
        precondition(self.offset < self.data.endIndex)
        defer { self.offset += 1 }
        return self.data[self.offset]
    }

    /**
     Reads `count` bytes and returns them as an array of `UInt8`, advancing by `count` positions.

     - Precondition: Parameter `count` MUST not be less than 0.
     - Precondition: There MUST be enough data left.
     */
    public func bytes(count: Int) -> [UInt8] {
        precondition(count >= 0)
        guard count > 0
            else { return [] }
        precondition(self.offset + count <= self.data.endIndex)
        defer { self.offset += count }
        return self.data[self.offset..<self.offset + count].toArray(type: UInt8.self, count: count)
    }

    /**
     Reads `fromBytes` bytes and returns them as an `Int` number, advancing by `fromBytes` positions.

     - Precondition: Parameter `fromBytes` MUST not be less than 0.
     - Precondition: There MUST be enough data left.
     */
    public func int(fromBytes count: Int) -> Int {
        precondition(count >= 0)
        guard count > 0
            else { return 0 }
        precondition(self.offset + count <= self.data.endIndex)
        // TODO: If uintX() could be force inlined or something in the future than probably it would make sense
        // to use them for `count` == 2, 4 or 8.
        var result = 0
        for i in 0..<count {
            result += Int(truncatingIfNeeded: self.data[self.offset]) << (8 * i)
            self.offset += 1
        }
        return result
    }

    /**
     Reads 8 bytes and returns them as a `UInt64` number, advancing by 8 positions.

     - Precondition: There MUST be enough data left.
     */
    public func uint64() -> UInt64 {
        precondition(self.offset + 8 <= self.data.endIndex)
        defer { self.offset += 8 }
        return self.data[self.offset..<self.offset + 8].to(type: UInt64.self)
    }

    /**
     Reads 4 bytes and returns them as a `UInt32` number, advancing by 4 positions.

     - Precondition: There MUST be enough data left.
     */
    public func uint32() -> UInt32 {
        precondition(self.offset + 4 <= self.data.endIndex)
        defer { self.offset += 4 }
        return self.data[self.offset..<self.offset + 4].to(type: UInt32.self)
    }

    /**
     Reads 2 bytes and returns them as a `UInt16` number, advancing by 2 positions.

     - Precondition: There MUST be enough data left.
     */
    public func uint16() -> UInt16 {
        precondition(self.offset + 2 <= self.data.endIndex)
        defer { self.offset += 2 }
        return self.data[self.offset..<self.offset + 2].to(type: UInt16.self)
    }

}
