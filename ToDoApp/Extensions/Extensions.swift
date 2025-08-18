import Foundation

func intToUUID(_ value: Int) -> UUID {
    let intBytes = withUnsafeBytes(of: value.bigEndian) { Array($0) }
    var bytes = [UInt8](repeating: 0, count: 16)
    for (offset, byte) in intBytes.enumerated() {
        bytes[16 - intBytes.count + offset] = byte
    }
    bytes[8] = (bytes[8] & 0x3F) | 0x80
    bytes[6] = (bytes[6] & 0x0F) | 0x40
    return UUID(uuid: (
        bytes[0], bytes[1], bytes[2], bytes[3],
        bytes[4], bytes[5], bytes[6], bytes[7],
        bytes[8], bytes[9], bytes[10], bytes[11],
        bytes[12], bytes[13], bytes[14], bytes[15]
    ))
}
