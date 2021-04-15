function jsonParse() {
    echo $1 | grep -oP "(?<=\"$2\" : \").*?((?=\",)|(?=\" }))"
}

getval=$(jsonParse '{ "chave1" : "valor1", "chave2" : "valor2" }\n 
      { "chave1" : "valor1", "chave2" : "valor2" }\n
      { "chave2" : "valor2", "chave1" : "valor1" }\n
      { "chave2" : "valor2", "chave1" : "valor1" } ' "chave1")

echo $getval


