 

## Resumo APT+DPKG - RPM - YUM

​	Apt é o administrador de pacotes .deb do sistema GNU/LINUX, por baixo é utilizado o comando dpkg.

​	O apt busca dos servidores listados no */etc/apt/sources* os pacotes .deb



##### Atualização de pacotes 

```bash
apt update	
# -----
yum update
```



##### Atualização Pacotes do Sistema

```bash
apt upgrade	
# -----
yum upgrade
```



##### Instalar um pacote 

```bash
apt install -y XXX
dpkg -i XXX.deb	
# -----
yum install -y XXXX
# -----
rpm -i -hv XXXX.rpm
```

##### Instalar dependencias

```bash
apt-f install
```



##### buscar um pacote

```bash
apt search XXX
apt cache search XXX
```



##### Verificar os instalados

```bash
dpkg -l # | grep XXX
dpkg selections
```



##### Para remover

```bash
apt remove --purge XXXX -y
apt autoremove # remove as libs/.deb dependendtes que não estão sendo utilizadas
# -----
yum remove XXXX
```



## Comandos

#### Comando para buscar o usuário:

- whoami
- echo $USER
- echo 



#### Informações Hardware e SO

- uname -a





## BASH

#### Histórico de comandos bash

$`cat ~/.bash_history`

$ `set | grep HIST`

$ `HISTSIZE=1000  `



#### Atalhos bash

$ `history`

$ `$ !s` Executa o ultimo comando executado coma  incial "s"

$ `$ !123` Executa o comando n 123 do "history"



#### Arquivo .bashrc

 .bashrc é o arquivo com toda a execução do bash.



#### Pré Bash - .bash_profile + .profile + login interativo shell

login interativo shell é a execução do shell por login, sem interface gráfica. Exemplos: tty, ssh

O login interativo vai executar uma ordem diferente de arquivos. Sendo ela:

​	/etc/profile

​	~/.bash_profile OU ~/.bash_login OU ~/.profile          O que encontrar primeiro



## Variaveis Globais e Locais

 env = Environment -> Globais

set = Locais



## File Globbing

##### Qualquer Coisa *

```bash
ls *.txt # Retorna qualquer Arquivo que termine com .txt
```



##### Caractere coringa

```bash
ls ?.txt # Substitui o "?" por qualquer letra -> a.txt, b.txt
```



##### Lista de caracteres

```bash
ls [Rr]eports*.txt # Reports.txt ou reports.txt ou reports1998-08-02.txt
```



##### Lista Negada

```bash
ls [^fFrR]* # Todos que não começam com f F r R
```



## Quotting " "



Aspas duplas " " identificam caracteres especiais $, * ...

```bash
echo "O usuário logado é o $LOGNAME"
#	O usuário logado é o Felipe

echo "O usuário logado é o \$LOGNAME"
#	O usuário logado é o $LOGNAME
```



Aspas simples não interpretam caracteres especiais

```bash
echo 'O usuário logado é o $LOGNAME'
#	O usuário logado é o $LOGNAME
```



## Detalhes do terminal

$ -> Usuario comum

\# -> super usuario



{comando} {parametro} {argumento}

ls -l .config/



### Encontrar diretorios e arquivos

##### $ locate

Utiliza a base de dados "updatedb" para rastrear todos os arquivos. Essa base de dados é carregada apenas quando o OS inciailiza

```bash
locate {file} 
```

Para atualizar a base de dados

```bash
sudo updatedb
```





##### $ find

 Busca todos os arquivos dentro do diretório .config com o nome terminando em .xml

```bash
find .config/ --iname *.xml
```



##### $ type

Comando para especificar o comando

```bash
type ls
# ls está apelidada para `ls --color=auto`
```



##### $ whereis

```bash
whereis firefox
```





## Compactar e Comprimir

Compactar X Comprimir

| Comando | Prós                        | Comentario                         | Comentario 2                     |
| ------- | --------------------------- | ---------------------------------- | -------------------------------- |
| tar     | Mais usual                  | Apenas compactador no comando puro | tar -cz = gzip \| tar -cj = bzip |
| zip     | Multiplataforma (windows)   | Não otimiza espaço na compressão   |                                  |
| xz      | Melhor otimização de espaço |                                    |                                  |



#### $ tar

Compactar junta todos os arquivos em uma pasta sem necessariamente diminuir o tamanho

Comprimir compacta os arquivos e diminui o tamanho utilizando um algoritmo



```bash
tar cvf {file.tar} /etc
# Compacta o etc para file.tar

tar cvfz {file.tar.gz} /etc
# Comprime o /etc ocupando MUITO menos espaço
# gzip file.tar.gz /etc

tar cvfj {file.tar.bz2} /etc
# Comprime o /etc ocupando menos espaço que o .gz
# bunzip2 file.tar.bz2 /etc
```



```bash
tar xvf file.tar
# Descompacta o file.tar

tar xjvf file.tar.bz2
# Descompacta o file.tar
# bunzip2 file.tar.bz2

tar xzvf file.tar
# Descompacta o file.tar.gz
# gunzip file.tar.gz
```

 Por tras os comandos "tar -cz " "tar -cj" são chamados os comandos gzip e bzip2

Os comandos "tar -xz" "tar -xj" chamam os comandos gunzip e bunzip2





#### $ zip

Não otimiza tamanho

```bash
zip -r file.zip /etc
unzip file.zip
```



#### $ xz

Melhor aprovetamento de armazenamento

```bash
xz /etc
unxz etc.xz
```





## Analise de arquivos/logs

#### $ less

#### $ head -n {numero de linhas}

#### $ tail -n {numero de linhas}



## Redirecionamentos de comandos

##### Standart In

* stdin 
  * Toda entrada no terminal (ls, echo, mkdir,...)

##### Standart Out 

* stdout

  * Toda saída sucesso do terminal (echo)

    

```bash
echo "Felipe" 
# Felipe --> saída sucesso
```



##### Standart Error 

* stderror 
  * Toda saída Erro do terminal 

```bash
apt update
# Reading package lists... Done
# E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)
# E: Unable to lock directory /var/lib/apt/lists/
# W: Problem unlinking the file /var/cache/apt/pkgcache.bin - RemoveCaches (13: Permission denied)
# W: Problem unlinking the file /var/cache/apt/srcpkgcache.bin - RemoveCaches (13: Permission denied)

```



| Standart | Comando                              |
| -------- | ------------------------------------ |
| STDOUT   | 1>           1>>         >        >> |
| STDERROR | 2>           2>>                     |

