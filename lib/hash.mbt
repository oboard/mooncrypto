pub struct Hash {
  data : Array[Int]
}

pub fn binl2hex(binarray : Array[Int]) -> String {
  let hex_tab = "0123456789abcdef"
  let mut str = ""
  for i = 0; i < binarray.length() * 4; i = i + 1 {
    str = str + hex_tab.get(binarray[i.asr(2)].asr(i % 4 * 8 + 4).land(0xF)).to_string() +
      hex_tab.get(binarray[i.asr(2)].asr(i % 4 * 8).land(0xF)).to_string()
  }
  return str
}

pub fn Hash::to_string(self : Hash) -> String {
  return binl2hex(self.data)
}
