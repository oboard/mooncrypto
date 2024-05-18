fn safe_add(x : Int, y : Int) -> Int {
  let lsw = x.land(0xffff) + y.land(0xffff)
  let msw = x.asr(16) + y.asr(16) + lsw.asr(16)
  msw.lsl(16).lor(lsw.land(0xffff))
}

// /*
//  *
//  * Bitwise rotate a 32-bit number to the left.
//  *
//  * 32位二进制数循环左移
//  *
//  */
fn bit_rol(num : Int, cnt : Int) -> Int {
  num.lsl(cnt).lor(num.lsr(32 - cnt))
}


// 大端序转小端序
pub fn bigToLittleEndian(bigEndian : Int) -> Int {
  bigEndian.land(0xff).lsl(24) // 最低位左移24位
  .lor(bigEndian.lsr(8).land(0xff).lsl(16)) // 第二低位左移16位
  .lor(bigEndian.lsr(16).land(0xff).lsl(8)) // 第三位左移8位
  .lor(bigEndian.lsr(24).land(0xff)) // 最高位保持不变
}

pub fn getUint32(bytes : Array[Int], byteOffset : Int) -> Int {
  // 从给定的字节偏移量开始读取四个字节
  let byte1 = bytes[byteOffset]
  let byte2 = bytes[byteOffset + 1]
  let byte3 = bytes[byteOffset + 2]
  let byte4 = bytes[byteOffset + 3]

  // 使用位移和按位或操作符（<< and |）来组合这些字节
  // 注意：这里假设字节序是大端序
  byte1.lsl(24).lor(byte2.lsl(16)).lor(byte3.lsl(8)).lor(byte4)
}