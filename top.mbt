fn md5() -> Unit {
  // b10a8db164e0754105b7a99be72e3fe5
  println(@mooncrypto.md5("Hello World"))
}

fn sha256() -> Unit {
  // a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e
  println(@mooncrypto.sha256("Hello World"))
}

fn sha1() -> Unit {
  // a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e
  println(@mooncrypto.sha1("Hello World"))
}

test {
  md5()
  sha1()
  sha256()
}
