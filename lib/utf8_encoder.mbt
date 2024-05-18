pub fn encodeUTF8(s : String) -> @vec.Vec[Int] {
  let r = []
  let mut c = 0
  let mut x = 0
  for i = 0; i < s.length(); i = i + 1 {
    c = s[i].to_int()
    r.append(
      if c < 0x80 {
        [c]
      } else if c < 0x800 {
        [0xC0 + c.asr(6).land(0x1F), 0x80 + c.land(0x3F)]
      } else {
        x = c.lxor(0xD800).asr(10)
        if x == 0 { //对四字节UTF-16转换为Unicode
          c = x.lsl(10) + s[i + 1].to_int().lxor(0xDC00) + 0x10000
          [0xF0 + c.asr(18).land(0x7), 0x80 + c.asr(12).land(0x3F)]
        } else {
          [0xE0 + c.asr(12).land(0xF)]
        } + [0x80 + c.asr(6).land(0x3F), 0x80 + c.land(0x3F)]
      },
    )
  }
  r
}
