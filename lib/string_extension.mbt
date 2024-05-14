pub fn join(arr : Array[String], sep : String) -> String {
  let mut str = ""
  for i = 0; i < arr.length(); i = i + 1 {
    if i > 0 {
      str = str + sep
    }
    str = str + arr[i]
  }
  return str
}
