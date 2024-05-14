pub fn fromCharCode(code_array : Array[Int]) -> String {
  let str = Buffer::make(code_array.length())
  for i = 0; i < code_array.length(); i = i + 1 {
    str.write_char(Char::from_int(code_array[i]))
  }
  str.to_string()
}
pub fn fromChars(code_array : Array[Char]) -> String {
  let str = Buffer::make(code_array.length())
  for i = 0; i < code_array.length(); i = i + 1 {
    str.write_char(code_array[i])
  }
  str.to_string()
}

pub fn ascii(ascii : Int) -> String {
  Char::from_int(ascii).to_string()
}
