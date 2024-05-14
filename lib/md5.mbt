let chrsz = 8 // bits per input character.

fn md5_cmn(q : Int, a : Int, b : Int, x : Int, s : Int, t : Int) -> Int {
  safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b)
}

fn safe_add(x : Int, y : Int) -> Int {
  let lsw = x.land(0xffff) + y.land(0xffff)
  let msw = x.asr(16) + y.asr(16) + lsw.asr(16)
  msw.lsl(16).lor(lsw.land(0xffff))
}

fn bit_rol(num : Int, cnt : Int) -> Int {
  num.lsl(cnt).lor(num.lsr(32 - cnt))
}

// 4组计算函数
fn md5_ff(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, t : Int) -> Int {
  md5_cmn(b.land(c).lor(b.lnot().land(d)), a, b, x, s, t)
}

fn md5_gg(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, t : Int) -> Int {
  md5_cmn(b.land(d).lor(c.land(d.lnot())), a, b, x, s, t)
}

fn md5_hh(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, t : Int) -> Int {
  md5_cmn(b.lxor(c).lxor(d), a, b, x, s, t)
}

fn md5_ii(a : Int, b : Int, c : Int, d : Int, x : Int, s : Int, t : Int) -> Int {
  md5_cmn(c.lxor(b.lor(d.lnot())), a, b, x, s, t)
}

fn core_md5(arr : Array[Int], len : Int) -> Array[Int] {
  let length = 16
  let x = Array::make(length, 0)
  for i = 0; i < arr.length(); i = i + 1 {
    x[i] = arr[i]
  }
  x[len.asr(5)] = x[len.asr(5)].lor((0x80).lsl(len % 32))
  x[(len + 64).lsr(9).lsl(4) + 14] = len
  let mut a = 1732584193
  let mut b = -271733879
  let mut c = -1732584194
  let mut d = 271733878
  for i = 0; i < x.length() - 1; i = i + 16 {
    let olda = a
    let oldb = b
    let oldc = c
    let oldd = d
    a = md5_ff(a, b, c, d, x[i + 0], 7, -680876936)
    d = md5_ff(d, a, b, c, x[i + 1], 12, -389564586)
    c = md5_ff(c, d, a, b, x[i + 2], 17, 606105819)
    b = md5_ff(b, c, d, a, x[i + 3], 22, -1044525330)
    a = md5_ff(a, b, c, d, x[i + 4], 7, -176418897)
    d = md5_ff(d, a, b, c, x[i + 5], 12, 1200080426)
    c = md5_ff(c, d, a, b, x[i + 6], 17, -1473231341)
    b = md5_ff(b, c, d, a, x[i + 7], 22, -45705983)
    a = md5_ff(a, b, c, d, x[i + 8], 7, 1770035416)
    d = md5_ff(d, a, b, c, x[i + 9], 12, -1958414417)
    c = md5_ff(c, d, a, b, x[i + 10], 17, -42063)
    b = md5_ff(b, c, d, a, x[i + 11], 22, -1990404162)
    a = md5_ff(a, b, c, d, x[i + 12], 7, 1804603682)
    d = md5_ff(d, a, b, c, x[i + 13], 12, -40341101)
    c = md5_ff(c, d, a, b, x[i + 14], 17, -1502002290)
    b = md5_ff(b, c, d, a, x[i + 15], 22, 1236535329)
    a = md5_gg(a, b, c, d, x[i + 1], 5, -165796510)
    d = md5_gg(d, a, b, c, x[i + 6], 9, -1069501632)
    c = md5_gg(c, d, a, b, x[i + 11], 14, 643717713)
    b = md5_gg(b, c, d, a, x[i + 0], 20, -373897302)
    a = md5_gg(a, b, c, d, x[i + 5], 5, -701558691)
    d = md5_gg(d, a, b, c, x[i + 10], 9, 38016083)
    c = md5_gg(c, d, a, b, x[i + 15], 14, -660478335)
    b = md5_gg(b, c, d, a, x[i + 4], 20, -405537848)
    a = md5_gg(a, b, c, d, x[i + 9], 5, 568446438)
    d = md5_gg(d, a, b, c, x[i + 14], 9, -1019803690)
    c = md5_gg(c, d, a, b, x[i + 3], 14, -187363961)
    b = md5_gg(b, c, d, a, x[i + 8], 20, 1163531501)
    a = md5_gg(a, b, c, d, x[i + 13], 5, -1444681467)
    d = md5_gg(d, a, b, c, x[i + 2], 9, -51403784)
    c = md5_gg(c, d, a, b, x[i + 7], 14, 1735328473)
    b = md5_gg(b, c, d, a, x[i + 12], 20, -1926607734)
    a = md5_hh(a, b, c, d, x[i + 5], 4, -378558)
    d = md5_hh(d, a, b, c, x[i + 8], 11, -2022574463)
    c = md5_hh(c, d, a, b, x[i + 11], 16, 1839030562)
    b = md5_hh(b, c, d, a, x[i + 14], 23, -35309556)
    a = md5_hh(a, b, c, d, x[i + 1], 4, -1530992060)
    d = md5_hh(d, a, b, c, x[i + 4], 11, 1272893353)
    c = md5_hh(c, d, a, b, x[i + 7], 16, -155497632)
    b = md5_hh(b, c, d, a, x[i + 10], 23, -1094730640)
    a = md5_hh(a, b, c, d, x[i + 13], 4, 681279174)
    d = md5_hh(d, a, b, c, x[i + 0], 11, -358537222)
    c = md5_hh(c, d, a, b, x[i + 3], 16, -722521979)
    b = md5_hh(b, c, d, a, x[i + 6], 23, 76029189)
    a = md5_hh(a, b, c, d, x[i + 9], 4, -640364487)
    d = md5_hh(d, a, b, c, x[i + 12], 11, -421815835)
    c = md5_hh(c, d, a, b, x[i + 15], 16, 530742520)
    b = md5_hh(b, c, d, a, x[i + 2], 23, -995338651)
    a = md5_ii(a, b, c, d, x[i + 0], 6, -198630844)
    d = md5_ii(d, a, b, c, x[i + 7], 10, 1126891415)
    c = md5_ii(c, d, a, b, x[i + 14], 15, -1416354905)
    b = md5_ii(b, c, d, a, x[i + 5], 21, -57434055)
    a = md5_ii(a, b, c, d, x[i + 12], 6, 1700485571)
    d = md5_ii(d, a, b, c, x[i + 3], 10, -1894986606)
    c = md5_ii(c, d, a, b, x[i + 10], 15, -1051523)
    b = md5_ii(b, c, d, a, x[i + 1], 21, -2054922799)
    a = md5_ii(a, b, c, d, x[i + 8], 6, 1873313359)
    d = md5_ii(d, a, b, c, x[i + 15], 10, -30611744)
    c = md5_ii(c, d, a, b, x[i + 6], 15, -1560198380)
    b = md5_ii(b, c, d, a, x[i + 13], 21, 1309151649)
    a = md5_ii(a, b, c, d, x[i + 4], 6, -145523070)
    d = md5_ii(d, a, b, c, x[i + 11], 10, -1120210379)
    c = md5_ii(c, d, a, b, x[i + 2], 15, 718787259)
    b = md5_ii(b, c, d, a, x[i + 9], 21, -343485551)
    a = a + olda
    b = b + oldb
    c = c + oldc
    d = d + oldd
  }
  [a, b, c, d]
}

pub fn hex_md5(s : String) -> String {
  binl2hex(core_md5(str2binl(s), s.length() * chrsz))
}

pub fn str2binl(str : String) -> Array[Int] {
  let bin = Array::make((str.length() * chrsz).asr(5) + 1, 0)
  let mask = (1).lsl(chrsz) - 1
  for i = 0; i < str.length() * chrsz; i = i + chrsz {
    bin[i.asr(5)] = bin[i.asr(5)].lor(
      str.get(i / chrsz).to_int().land(mask).lsl(i % 32),
    )
  }
  bin
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

// fn binl2b64(binarray : Bytes) -> String {
//   let b64_tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
//   let mut str = ""
//   let b64pad = "="
//   for i = 0; i < binarray.length() * 4; i = i + 3 {
//     let triplet = (binarray[i.asr(2)].asr(8) * (i % 4)).land(0xFF).lsl(16).lor(
//       (binarray[(i + 1).asr(2)].asr(8) * ((i + 1) % 4)).land(0xFF).lsl(8),
//     ).lor((binarray[(i + 2).asr(2)].asr(8) * ((i + 2) % 4)).land(0xFF))
//     for j = 0; j < 4; j = j + 1 {
//       if i * 8 + j * 6 > binarray.length() * 32 {
//         str = str + b64pad
//       } else {
//         str += b64_tab.get(triplet.asr(6 * (3 - j)).land(0x3F)).to_string()
//       }
//     }
//   }
//   str
// }

// fn pow(x : Int, n : Int) -> Int {
//   if n == 0 {
//     return 1
//   }
//   let y = pow(x, n / 2)
//   if n % 2 == 0 {
//     return y * y
//   } else {
//     return x * y * y
//   }
// }

test {
  // ✅
  // println((457565).lsr(163212))

  // ✅
  // println(binl2hex(str2binl("abc")))

  // ✅
  // "900150983cd24fb0d6963f7d28e17f72"
  println(hex_md5("abc"))
}
