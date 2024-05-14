pub fn md5() -> Unit {
  println(@mooncrypto.md5("Hello, World!"))
}

test {
  md5()
}
