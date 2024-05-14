
pub struct TextDecoder {
  
}

pub fn TextDecoder::decode(bytes : Array[Int]) -> String {
  // 将字节数组转换为字符串
  let mut str = ""
  for i = 0; i < bytes.length(); i = i + 1 {
    str += ascii(bytes[i])
  }
  return str
}