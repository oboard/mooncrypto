pub fn byteArrayToIntArray(byteArray : Array[Int]) -> Array[Int] {
  let intArray = Array::make(byteArray.length() / 4, 0)
  for i = 0; i < intArray.length(); i = i + 1 {
    let index = i * 4
    intArray[i] = byteArray[index].lsl(24).lor(byteArray[index + 1].lsl(16)).lor(
      byteArray[index + 2].lsl(8),
    ).lor(byteArray[index + 3])
  }
  return intArray
}

pub fn bytes_to_array(bytes : Bytes) -> Array[Int] {
  let array = Array::make(bytes.length(), 0)
  for i = 0; i < bytes.length(); i = i + 1 {
    array[i] = bytes[i]
  }
  array
}
