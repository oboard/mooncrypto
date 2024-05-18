pub enum HashType {
  MD5
  SHA1
  SHA256
  SHA512
}

pub struct Hash {
  data : Array[Int]
  hash_type : HashType
}


pub fn hexChar(byte : Int) -> String {
  let hex_tab = "0123456789abcdef"
  return hex_tab.get(byte.asr(4)).to_string() + hex_tab.get(byte.land(0xF)).to_string()
}

pub fn hex_array(arr : Array[Int]) -> String {
  let mut str = ""
  for i = 0; i < arr.length(); i = i + 1 {
    str = str + hexChar(arr[i].land(0xff))
  }
  return str
}

pub fn Hash::to_string(self : Hash) -> String {
  match self.hash_type {
    MD5 => binl2hex(self.data)
    SHA1 => binb2hex(self.data)
    SHA256 => hex_array(self.data)
    SHA512 => hex_array(self.data)
  }
}
