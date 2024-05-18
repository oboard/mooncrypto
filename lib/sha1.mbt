// /*
//  *
//  * Calculate the SHA-1 of an array of big-endian words, and a bit length
//  *
//  */
pub fn core_sha1(blockArray : Array[Int]) -> Array[Int] {
  let x = blockArray // append padding
  let w = Array::make(80, 0)
  let mut a = 1732584193
  let mut b = -271733879
  let mut c = -1732584194
  let mut d = 271733878
  let mut e = -1009589776
  for i = 0; i < x.length(); i = i + 16 {
    // 每次处理512位 16*32
    let olda = a
    let oldb = b
    let oldc = c
    let oldd = d
    let olde = e
    for j = 0; j < 80; j = j + 1 {
      // 对每个512位进行80步操作
      if j < 16 {
        w[j] = x[i + j]
      } else {
        w[j] = bit_rol(
          w[j - 3].lxor(w[j - 8]).lxor(w[j - 14]).lxor(w[j - 16]),
          1,
        )
      }
      let t = (bit_rol(a, 5) + sha1_ft(j, b, c, d) + e + w[j] + sha1_kt(j)).lor(
        0,
      )
      e = d
      d = c
      c = bit_rol(b, 30)
      b = a
      a = t
    }
    a += olda
    b += oldb
    c += oldc
    d += oldd
    e += olde
  }
  [a, b, c, d, e]
}

// /*
//  *
//  * The main function to calculate message digest
//  *
//  */
pub fn sha1(s : String) -> Hash {
  { data: core_sha1(alignSHA1(s)), hash_type: SHA1 }
}

// /*
//  *
//  * Perform the appropriate triplet combination function for the current
//  * iteration
//  *
//  * 返回对应F函数的值
//  *
//  */
// function sha1_ft(t, b, c, d) {
//   if (t < 20) return (b & c) | (~b & d);
//   if (t < 40) return b ^ c ^ d;
//   if (t < 60) return (b & c) | (b & d) | (c & d);
//   return b ^ c ^ d; // t<80
// }

fn sha1_ft(t : Int, b : Int, c : Int, d : Int) -> Int {
  if t < 20 {
    b.land(c).lor(b.lnot().land(d))
  } else if t < 40 {
    b.lxor(c).lxor(d)
  } else if t < 60 {
    b.land(c).lor(b.land(d)).lor(c.land(d))
  } else {
    b.lxor(c).lxor(d)
  }
}

// /*
//  *
//  * Determine the appropriate additive constant for the current iteration
//  *
//  * 返回对应的Kt值
//  *
//  */

fn sha1_kt(t : Int) -> Int {
  if t < 20 {
    1518500249
  } else if t < 40 {
    1859775393
  } else if t < 60 {
    -1894007588
  } else {
    -899497514
  }
}

// /*
//  *
//  * The standard SHA1 needs the input string to fit into a block
//  *
//  * This function align the input string to meet the requirement
//  *
//  */

fn alignSHA1(str : String) -> Array[Int] {
  let len = str.length()
  let nblk = (len + 8).asr(6) + 1
  let blks = Array::make(nblk * 16, 0)
  for i = 0; i < len; i = i + 1 {
    blks[i.asr(2)] = blks[i.asr(2)].lor(str[i].to_int().lsl(24 - i.land(3) * 8))
  }
  blks[len.lsr(2)] = blks[len.lsr(2)].lor((0x80).lsl(24 - len.land(3) * 8))
  blks[nblk * 16 - 1] = len * 8
  blks
}

test {
  // ✅
  // println(alignSHA1("abc"))
  // ✅
  println(sha1("Hello World"))
}
