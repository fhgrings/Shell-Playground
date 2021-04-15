| Comparação de Strings | Descrição                                 |
| --------------------- | ----------------------------------------- |
| Str1 = Str2           | Retorna true se as Strings são iguais     |
| Str1 != Str2          | Retorna true se as Strings não são iguais |
| -n Str1               | Retorna true se a String não é null       |
| -z Str1               | Retorna true se a String é null           |

| Comparação Numérica | Descrição                                                    |
| ------------------- | ------------------------------------------------------------ |
| expr1 -eq expr2     | Retorna true se os valores são iguais                        |
| expr1 -ne expr2     | Retorna true se os valores não são iguais                    |
| expr1 -gt expr2     | Retorna true se o expr1 é maior que o expr2                  |
| expr1 -ge expr2     | Retorna true se o expr1 é maior ou igual ao expr2            |
| expr1 -lt expr2     | Retorna true se o expr1 é menor que o expr2                  |
| expr1 -le expr2     | Retorna trues se o expr1 é menor ou igual ao expr2           |
| ! expr1             | Nega o resultado da expressão (se for true vira false e vice-versa) |

| Condicionais de arquivos | Descrição                                                    |
| ------------------------ | ------------------------------------------------------------ |
| -d file                  | Retorna se for um diretório                                  |
| -e file                  | Retorna true se o arquivo existir                            |
| -f file                  | Retorna true se o arquivo existir (-f é mais usado porque é mais portável) |
| -g file                  | Retorna true se o GID estiver habilitado no arquivo          |
| -r file                  | Retorna true se o arquivo tiver permissão de leitura         |
| -s file                  | Retorna true se o arquivo tiver um tamanho diferente de zero |
| -u                       | Retorna true se o UID estiver habilitado no arquivo          |
| -w                       | Retorna true se o arquivo tiver permissão de escrita         |
| -x                       | Reteorna true se o arquivo tiver permissão de execução       |



## Expressões Regulares

| Operador  | Descrição                                                    |
| --------- | ------------------------------------------------------------ |
| ^         | Inicio de linha                                              |
| $         | Fim de linha                                                 |
| .         | Curinga que representa um caractere                          |
| +         | O Dígito anterior deve aparecer uma vez ou mais              |
| [ ... ]   | Lista de caracteres (Funciona para todos caracteres dentro da lista) |
| [ ^ ... ] | Negação da lista                                             |
| \|        | Ou                                                           |
| .*        | Curinga para qualquer coisa                                  |
| *         | O digito anterior pode aparecer em qualquer quantidade       |
| {,}       | O digito anterior deve aparecer na quantidade indicada       |

##### Exemplos

^a = Qualquer linha que inicie com a

h$ = Qualquer linha que termine com h

^[b c] = Qualquer linha que comece com "b" OU "c"

^[ ^ b c ] = Qualquer linha que NÃO comece com "b" OU "c"

^r.*h$ = Tudo que começa com "r" e termina com "h"  *!=* ^rh* = Apenas palavras "rh" 

^.[ab] = Qualquer palavra que a segunda letra seja A ou B



##### Exemplo Expressão extendida

egrep "^a.{10,50}h" /etc/passwd = Qualquer linha que contenha entre 10 e 50 caracteres

egrep "felipe|root" /etc/passwd = Qualinha linha que contenha felipe OU matheus



##### Lookbehind
echo "cebbrito cabbrito" | grep -oP "(?<=cab)rito" # rito
echo "cebbrito cabbrito" | grep -oP '(?<!TESTE)brito'

##### Lookahead
echo "cebbrito cabbrito" | grep -oP 'b(?=brito)'    # b \n b
echo "cebbrito cabbrito" | grep -oP 'cab(?!TESTE)'    # cab