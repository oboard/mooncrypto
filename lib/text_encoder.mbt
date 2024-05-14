

pub fn encodeUTF8(str : String) -> String {
  let mut utf8Str = ""
  for i = 0; i < str.length(); i = i + 1 {
    let charCode = str[i].to_int()
    if charCode < 0x80 {
      utf8Str += str[i].to_string()
    } else if charCode < 0x800 {
      utf8Str += fromCharCode(
        [
          (0xc0).lor(
            // utf8Str += String.fromCharCode(0xc0 | (charCode >> 6),
            //                                 0x80 | (charCode & 0x3f));
            charCode.asr(6),
          ),
          (0x80).lor(charCode.land(0x3f)),
        ],
      )
    } else if charCode < 0xd800 || charCode >= 0xe000 {
      utf8Str += fromCharCode(
        [
          (0xe0).lor(
            // utf8Str += String.fromCharCode(0xe0 | (charCode >> 12),
            //                                 0x80 | ((charCode >> 6) & 0x3f),
            //                                 0x80 | (charCode & 0x3f));
            charCode.asr(12),
          ),
          (0x80).lor(charCode.asr(6).land(0x3f)),
          (0x80).lor(charCode.land(0x3f)),
        ],
      )
    } else {
      // 对于代理对 (charCode >= 0xd800 && charCode < 0xdc00) 或 (charCode >= 0xdc00 && charCode < 0xe000)
      let surrogate1 = charCode
      // let surrogate2 = str.charCodeAt(++i);
      let surrogate2 = str[i + 1].to_int()
      let codePoint = (surrogate1 - 0xd800) * 0x400 + (surrogate2 - 0xdc00) + 0x10000
      utf8Str += fromCharCode(
        [
          (0xf0).lor(
            // utf8Str += String.fromCharCode(0xf0 | ((codePoint >> 18) & 0x3f),
            //                                 0x80 | ((codePoint >> 12) & 0x3f),
            //                                 0x80 | ((codePoint >> 6) & 0x3f),
            //                                 0x80 | (codePoint & 0x3f));
            codePoint.asr(18).land(0x3f),
          ),
          (0x80).lor(codePoint.asr(12).land(0x3f)),
          (0x80).lor(codePoint.asr(6).land(0x3f)),
          (0x80).lor(codePoint.land(0x3f)),
        ],
      )
    }
  }
  return utf8Str
}

pub struct TextEncoder {}

pub fn TextEncoder::encode(str : String) -> Array[Int] {
  // 将字符串转换为 UTF-8 编码的字符数组
  let mut encodedList : List[Int] = List::Nil
  let utf8Array = encodeUTF8(str)
  for i = 0; i < utf8Array.length(); i = i + 1 {
    encodedList = Cons(utf8Array[i].to_int(), encodedList)
  }
  return encodedList.reverse().to_array()
}
