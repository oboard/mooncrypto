// let digestLength = 32

// let blockSize = 64

pub struct Sha256Hash {
  mut digestLength : Int
  mut blockSize : Int
  // Note: Int32Array is used instead of Uint32Array for performance reasons.
  mut state : Array[Int] // hash state
  mut temp : Array[Int] // temporary state
  mut buffer : Array[Int] // buffer for data to hash
  mut bufferLength : Int // number of bytes in buffer
  mut bytesHashed : Int // number of total bytes hashed
  mut finished : Bool // indicates whether the hash was finalized
}

let default_state = [
  0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab,
  0x5be0cd19,
]

fn Sha256Hash::new() -> Sha256Hash {
  {
    digestLength: 32,
    blockSize: 64,
    state: default_state,
    temp: Array::make(64, 0),
    buffer: Array::make(128, 0),
    bufferLength: 0,
    bytesHashed: 0,
    finished: false,
  }
}

fn Sha256Hash::reset(self : Sha256Hash) -> Unit {
  self.state = default_state
  self.bufferLength = 0
  self.bytesHashed = 0
  self.finished = false
}

fn Sha256Hash::clean(self : Sha256Hash) -> Unit {
  for i = 0; i < self.buffer.length(); i = i + 1 {
    self.buffer[i] = 0
  }
  for i = 0; i < self.temp.length(); i = i + 1 {
    self.temp[i] = 0
  }
  self.reset()
}

// Internal function for use in HMAC for optimization.

fn Sha256Hash::_saveState(self : Sha256Hash, out : Array[Int]) -> Unit {
  for i = 0; i < self.state.length(); i = i + 1 {
    out[i] = self.state[i]
  }
}

// ✅
fn Sha256Hash::finish(self : Sha256Hash, out : Array[Int]) -> Sha256Hash {
  if self.finished.not() {
    let bytesHashed = self.bytesHashed
    let left = self.bufferLength
    let bitLenHi = (bytesHashed / 0x20000000).lor(0)
    let bitLenLo = bytesHashed.lsl(3)
    let padLength = if bytesHashed % 64 < 56 { 64 } else { 128 }
    self.buffer[left] = 0x80
    for i = left + 1; i < padLength - 8; i = i + 1 {
      self.buffer[i] = 0
    }
    self.buffer[padLength - 8] = bitLenHi.lsr(24).land(0xff)
    self.buffer[padLength - 7] = bitLenHi.lsr(16).land(0xff)
    self.buffer[padLength - 6] = bitLenHi.lsr(8).land(0xff)
    self.buffer[padLength - 5] = bitLenHi.lsr(0).land(0xff)
    self.buffer[padLength - 4] = bitLenLo.lsr(24).land(0xff)
    self.buffer[padLength - 3] = bitLenLo.lsr(16).land(0xff)
    self.buffer[padLength - 2] = bitLenLo.lsr(8).land(0xff)
    self.buffer[padLength - 1] = bitLenLo.lsr(0).land(0xff)
    let _ = hashBlocks(self.temp, self.state, self.buffer, 0, padLength)
    self.finished = true
  }
  for i = 0; i < 8; i = i + 1 {
    out[i * 4 + 0] = self.state[i].lsr(24).land(0xff)
    out[i * 4 + 1] = self.state[i].lsr(16).land(0xff)
    out[i * 4 + 2] = self.state[i].lsr(8).land(0xff)
    out[i * 4 + 3] = self.state[i].lsr(0).land(0xff)
  }
  self
}

// Internal function for use in HMAC for optimization.
fn Sha256Hash::_restoreState(
  self : Sha256Hash,
  from : Array[Int],
  bytesHashed : Int
) -> Unit {
  for i = 0; i < self.state.length(); i = i + 1 {
    self.state[i] = from[i]
  }
  self.bytesHashed = bytesHashed
  self.finished = false
  self.bufferLength = 0
}

// SHA-256 constants
let k = [
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4,
  0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe,
  0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f,
  0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
  0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc,
  0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
  0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116,
  0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
  0xc67178f2,
]

// ✅
fn hashBlocks(
  w : Array[Int],
  v : Array[Int],
  p : Array[Int],
  pos : Int,
  len : Int
) -> Int {
  // let a: number, b: number, c: number, d: number, e: number,
  //     f: number, g: number, h: number, u: number, i: number,
  //     j: number, t1: number, t2: number;
  let mut a = 0
  let mut b = 0
  let mut c = 0
  let mut d = 0
  let mut e = 0
  let mut f = 0
  let mut g = 0
  let mut h = 0
  let mut u = 0
  let mut j = 0
  let mut t1 = 0
  let mut t2 = 0
  let mut position = pos
  let mut length = len
  while length >= 64 {
    a = v[0]
    b = v[1]
    c = v[2]
    d = v[3]
    e = v[4]
    f = v[5]
    g = v[6]
    h = v[7]

    // for (i = 0; i < 16; i++) {
    for i = 0; i < 16; i = i + 1 {
      j = position + i * 4
      // w[i] = (((p[j] & 0xff) << 24) | ((p[j + 1] & 0xff) << 16) |
      //         ((p[j + 2] & 0xff) <<  8) | (p[j + 3] & 0xff));
      w[i] = p[j].land(0xff).lsl(24).lor(
        p[j + 1].land(0xff).lsl(16).lor(
          p[j + 2].land(0xff).lsl(8).lor(p[j + 3].land(0xff)),
        ),
      )
    }

    // for (i = 16; i < 64; i++) {
    for i = 16; i < 64; i = i + 1 {
      u = w[i - 2]
      // t1 = (u >>> 17 | u << (32 - 17)) ^ (u >>> 19 | u << (32 - 19)) ^ (u >>> 10);
      t1 = u.lsr(17).lor(u.lsl(15)).lxor(
        u.lsr(19).lor(u.lsl(13)).lxor(u.lsr(10)),
      )
      u = w[i - 15]
      // t2 = (u >>> 7 | u << (32 - 7)) ^ (u >>> 18 | u << (32 - 18)) ^ (u >>> 3);
      t2 = u.lsr(7).lor(u.lsl(25)).lxor(u.lsr(18).lor(u.lsl(14)).lxor(u.lsr(3)))

      // w[i] = (t1 + w[i - 7] | 0) + (t2 + w[i - 16] | 0);
      w[i] = (t1 + w[i - 7]).lor(0) + (t2 + w[i - 16]).lor(0)
    }

    // for i = 0; i < 64; i++) {
    for i = 0; i < 64; i = i + 1 {
      // t1 = (((((e >>> 6 | e << (32 - 6)) ^ (e >>> 11 | e << (32 - 11)) ^
      //           (e >>> 25 | e << (32 - 25))) + ((e & f) ^ (~e & g))) | 0) +
      //             ((h + ((K[i] + w[i]) | 0)) | 0)) | 0;
      t1 = ((e.lsr(6).lor(e.lsl(26)).lxor(
        e.lsr(11).lor(e.lsl(21)).lxor(e.lsr(25).lor(e.lsl(7))),
      ) + e.land(f).lxor(e.lnot().land(g))).lor(0) + (h + (k[i] + w[i]).lor(0)).lor(
        0,
      )).lor(0)

      // t2 = (((a >>> 2 | a << (32 - 2)) ^ (a >>> 13 | a << (32 - 13)) ^
      //       (a >>> 22 | a << (32 - 22))) + ((a & b) ^ (a & c) ^ (b & c))) | 0;
      t2 = (a.lsr(2).lor(a.lsl(30)).lxor(
        a.lsr(13).lor(a.lsl(19)).lxor(a.lsr(22).lor(a.lsl(10))),
      ) + a.land(b).lxor(a.land(c)).lxor(b.land(c))).lor(0)
      h = g
      g = f
      f = e
      // e = (d + t1) | 0;
      e = (d + t1).lor(0)
      d = c
      c = b
      b = a
      // a = (t1 + t2) | 0;
      a = (t1 + t2).lor(0)
    }
    v[0] += a
    v[1] += b
    v[2] += c
    v[3] += d
    v[4] += e
    v[5] += f
    v[6] += g
    v[7] += h
    position += 64
    length -= 64
  }
  position
}

// ✅
fn Sha256Hash::update(
  self : Sha256Hash,
  data : Array[Int],
  dataLength : Int
) -> Sha256Hash {
  let mut length = dataLength
  if self.finished {
    abort("SHA256: can't update because hash was finished.")
  }
  let mut dataPos = 0
  self.bytesHashed += length
  if self.bufferLength > 0 {
    while self.bufferLength < 64 && length > 0 {
      self.buffer[self.bufferLength] = data[dataPos]
      dataPos += 1
      self.bufferLength += 1
      length -= 1
    }
    if self.bufferLength == 64 {
      let _ = hashBlocks(self.temp, self.state, self.buffer, 0, 64)
      self.bufferLength = 0
    }
  }
  if length >= 64 {
    dataPos = hashBlocks(self.temp, self.state, data, dataPos, length)
    length %= 64
  }
  while length > 0 {
    self.buffer[self.bufferLength] = data[dataPos]
    dataPos += 1
    self.bufferLength += 1
    length -= 1
  }
  self
}

pub fn Sha256Hash::digest(self : Sha256Hash) -> Array[Int] {
  let out = Array::make(self.digestLength, 0)
  let _ = self.finish(out)
  out
}

// ✅
pub fn core_sha256(data : Array[Int]) -> Hash {
  let h = Sha256Hash::new().update(data, data.length())
  let digest = h.digest()
  h.clean()
  { data: digest, hash_type: SHA256 }
}

pub fn sha256(str : String) -> Hash {
  let data = TextEncoder::encode(str)
  core_sha256(data)
}
