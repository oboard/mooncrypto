// function encodeUTF8(s) {
//   var i, r = [], c, x;
//   for (i = 0; i < s.length; i++)
//     if ((c = s.charCodeAt(i)) < 0x80) r.push(c);
//     else if (c < 0x800) r.push(0xC0 + (c >> 6 & 0x1F), 0x80 + (c & 0x3F));
//     else {
//       if ((x = c ^ 0xD800) >> 10 == 0) //对四字节UTF-16转换为Unicode
//         c = (x << 10) + (s.charCodeAt(++i) ^ 0xDC00) + 0x10000,
//           r.push(0xF0 + (c >> 18 & 0x7), 0x80 + (c >> 12 & 0x3F));
//       else r.push(0xE0 + (c >> 12 & 0xF));
//       r.push(0x80 + (c >> 6 & 0x3F), 0x80 + (c & 0x3F));
//     };
//   return r;
// }

fn encodeUTF8(s : String) -> @vec.Vec[Int] {
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

// // 字符串加密成 hex 字符串
// function sha1(s) {
//   var data = new Uint8Array(encodeUTF8(s))
//   var i, j, t;
//   var l = ((data.length + 8) >>> 6 << 4) + 16, s = new Uint8Array(l << 2);
//   s.set(new Uint8Array(data.buffer)), s = new Uint32Array(s.buffer);
//   for (t = new DataView(s.buffer), i = 0; i < l; i++)s[i] = t.getUint32(i << 2);
//   s[data.length >> 2] |= 0x80 << (24 - (data.length & 3) * 8);
//   s[l - 1] = data.length << 3;
//   var w = [], f = [
//     function () { return m[1] & m[2] | ~m[1] & m[3]; },
//     function () { return m[1] ^ m[2] ^ m[3]; },
//     function () { return m[1] & m[2] | m[1] & m[3] | m[2] & m[3]; },
//     function () { return m[1] ^ m[2] ^ m[3]; }
//   ], rol = function (n, c) { return n << c | n >>> (32 - c); },
//     k = [1518500249, 1859775393, -1894007588, -899497514],
//     m = [1732584193, -271733879, null, null, -1009589776];
//   m[2] = ~m[0], m[3] = ~m[1];
//   for (i = 0; i < s.length; i += 16) {
//     var o = m.slice(0);
//     for (j = 0; j < 80; j++)
//       w[j] = j < 16 ? s[i + j] : rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1),
//         t = rol(m[0], 5) + f[j / 20 | 0]() + m[4] + w[j] + k[j / 20 | 0] | 0,
//         m[1] = rol(m[1], 30), m.pop(), m.unshift(t);
//     for (j = 0; j < 5; j++)m[j] = m[j] + o[j] | 0;
//   };
// t = new DataView(new Uint32Array(m).buffer);
// for (var i = 0; i < 5; i++)m[i] = t.getUint32(i << 2);

// var hex = Array.prototype.map.call(new Uint8Array(new Uint32Array(m).buffer), function (e) {
//   return (e < 16 ? "0" : "") + e.toString(16);
// }).join("");

// for (var i = 0; i < 5; i++) {
//   // 假设m是一个已经初始化的数组，这里直接使用m[i]
//   m[i] = m[i] || 0; // 如果m[i]未定义，则设置为0
//   hex.push((m[i] & 0xFF).toString(16).padStart(2, '0'));
// }

// hex = hex.join("");
//   return hex;
// }

fn getInt64(bytes : Array[Int64], byteOffset : Int) -> Int64 {
  // 从给定的字节偏移量开始读取四个字节
  let byte1 = bytes[byteOffset]
  let byte2 = bytes[byteOffset + 1]
  let byte3 = bytes[byteOffset + 2]
  let byte4 = bytes[byteOffset + 3]

  // 使用位移和按位或操作符（<< and |）来组合这些字节
  // 注意：这里假设字节序是大端序
  byte1.lsl(24).lor(byte2.lsl(16)).lor(byte3.lsl(8)).lor(byte4)
}

fn getUint32(bytes : Array[Int], byteOffset : Int) -> Int {
  // 从给定的字节偏移量开始读取四个字节
  let byte1 = bytes[byteOffset]
  let byte2 = bytes[byteOffset + 1]
  let byte3 = bytes[byteOffset + 2]
  let byte4 = bytes[byteOffset + 3]

  // 使用位移和按位或操作符（<< and |）来组合这些字节
  // 注意：这里假设字节序是大端序
  byte1.lsl(24).lor(byte2.lsl(16)).lor(byte3.lsl(8)).lor(byte4)
}

// fn pow64(x : Int64, n : Int64) -> Int64 {
//   // 计算2^n
//   let mut result = x
//   for i = 0L; i < n; i = i + 1L {
//     result *= x
//   }
//   result
// }

fn int32ToUint32(input : Int) -> Int64 {
  if input < 0 {
    4294967296L + input.to_int64()
  } else {
    input.to_int64()
  }
  // // 计算2^32
  // let twoTo32 = 8589934592L
  // let mut int64 = input.to_int64()

  // // 如果int32小于0，加上2^32使其成为正数
  // if int64 < 0L {
  //   int64 += twoTo32
  // }

  // // 使用模运算得到uint32
  // return int64 % twoTo32
}

fn sha1(s : String) -> String {
  let data = encodeUTF8(s)
  let mut t = 0
  let l = (data.length() + 8).lsr(6).lsl(4) + 16
  println(l)
  let s = Array::make(l.lsl(2), 0)
  for i = 0; i < data.length(); i = i + 1 {
    s[i] = data[i.lsl(2)]
  }
  for i = 0; i < l; i = i + 1 {
    s[i] = getUint32(s, i.lsl(2))
  }
  s[data.length().asr(2)] = s[data.length().asr(2)].lor(
    (0x80).lsl(24 - data.length().land(3) * 8),
  )
  s[l - 1] = data.length().lsl(3)
  let k = [1518500249, 1859775393, -1894007588, -899497514]
  let m = [1732584193, -271733879, 0, 0, -1009589776]
  let w = Array::make(80, 0)
  let f = [
    // *
    fn() -> Int { m[1].land(m[2]).lor(m[1].lnot().land(m[3])) },
    fn() -> Int { m[1].lxor(m[2]).lxor(m[3]) },
    fn() -> Int { m[1].land(m[2]).lor(m[1].land(m[3])).lor(m[2].land(m[3])) },
    fn() -> Int { m[1].lxor(m[2]).lxor(m[3]) },
  ]
  fn rol(n : Int, c : Int) -> Int {
    n.lsl(c).lor(n.lsr(32 - c))
  }

  m[2] = m[0].lnot()
  m[3] = m[1].lnot()
  for i = 0; i < s.length() / 4; i = i + 16 {
    let o = Array::make(m.length(), 0)
    // copy m to o
    for j = 0; j < m.length(); j = j + 1 {
      o[j] = m[j]
    }
    for j = 0; j < 80; j = j + 1 {
      w[j] = if j < 16 {
        s[i + j]
      } else {
        rol(w[j - 3].lxor(w[j - 8]).lxor(w[j - 14]).lxor(w[j - 16]), 1)
      }
      t = (rol(m[0], 5) + f[(j / 20).lor(0)]() + m[4] + w[j] + k[(j / 20).lor(0)]).lor(
        0,
      )
      m[1] = rol(m[1], 30)
      let _ = m.pop()
      m.insert(0, t)
    }
    for j = 0; j < 5; j = j + 1 {
      m[j] = (m[j] + o[j]).lor(0)
    }
  }
  // let m_arr = m.to_list().map(int32ToUint32).to_array()
  // // println(m_arr)
  // for i = 0; i < 5; i = i + 1 {
  //   m_arr[i] = getInt64(m_arr, i.lsl(2))
  // }
  binl2hex(m.to_list().to_array())
}

test {
  println(sha1("1"))
  // println(int32ToUint32(-1))
}
