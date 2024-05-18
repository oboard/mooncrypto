

// /*
//  * Convert an array of little-endian words to a hex string.
//  *
//  */
pub fn binl2hex(binarray : Array[Int]) -> String {
  let hex_tab = "0123456789abcdef"
  let mut str = ""
  for i = 0; i < binarray.length() * 4; i = i + 1 {
    str = str + hex_tab.get(binarray[i.asr(2)].asr(i % 4 * 8 + 4).land(0xF)).to_string() +
      hex_tab.get(binarray[i.asr(2)].asr(i % 4 * 8).land(0xF)).to_string()
  }
  return str
}


// /*
//  *
//  * Convert an array of big-endian words to a hex string.
//  *
//  */
pub fn binb2hex(binarray : Array[Int]) -> String {
  let hex_tab = "0123456789abcdef"
  let mut str = ""
  for i = 0; i < binarray.length() * 4; i = i + 1 {
    let byte = binarray[i.asr(2)].asr((3 - i % 4) * 8 + 4).land(0xf)
    str = str + hex_tab[byte].to_string() + hex_tab[binarray[i.asr(2)].asr(
        (3 - i % 4) * 8,
      ).land(0xf)].to_string()
  }
  str
}