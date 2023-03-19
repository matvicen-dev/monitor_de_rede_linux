# monitor_de_rede_linux
# Monitor de Rede para Linux

Este é um script escrito em Shell Script para monitorar a taxa de transferência de dados em uma interface de rede no sistema operacional Linux. O script lê o arquivo "/proc/net/dev" e apresenta o throughput (vazão) de download e upload da rede. O usuário pode definir o intervalo de tempo entre as leituras e a duração total do monitoramento. As informações de vazão são armazenadas em um arquivo de texto chamado "file.dat". Depois de concluído o monitoramento, um gráfico é gerado com as informações armazenadas no arquivo "file.dat" usando o software "gnuplot".

## Pré-requisitos
Este script foi desenvolvido para o sistema operacional Linux e requer o software "gnuplot" instalado para gerar o gráfico. Para instalar o gnuplot, basta executar o seguinte comando no terminal:
```bash
sudo apt-get install gnuplot
```

## Como usar
O script pode ser executado a partir do terminal com o seguinte comando:
```bash
./monitor.sh <intervalo> <duracao>
```
Onde: 
  - **`<intervalo>`**: é o intervalo de tempo entre as leituras, em segundos.
  - **`<duracao>`**: é a duração total do monitoramento, em minutos.
  
Por exemplo, se quisermos monitorar a taxa de transferência a cada 5 segundos durante 1 hora, podemos executar o seguinte comando:
  ```bash
  ./monitor.sh 5 60
  ```
Isso irá ler as informações de vazão a cada 5 segundos durante 1 hora e armazená-las no arquivo "file.dat". Em seguida, um gráfico será gerado usando o gnuplot.
  
## Como funciona
O script funciona da seguinte maneira:
1. Verifica se o gnuplot está instalado. Se não estiver, exibe uma mensagem de erro e sai do script.
2. Define as variáveis intervalo e duracao com base nos parâmetros de entrada.
3. Define o nome da interface de rede a ser monitorada.
4. Cria o arquivo "file.dat" ou limpa o conteúdo se o arquivo já existir.
5. Executa um loop que lê as informações de vazão a cada intervalo segundos e as armazena no arquivo "file.dat" até atingir a duração total especificada.
6. Usa o gnuplot para gerar um gráfico com as informações armazenadas no arquivo "file.dat".

O script utiliza as seguintes funções:
+ verificar_gnuplot
Esta função verifica se o gnuplot está instalado no sistema. Se o gnuplot não estiver instalado, exibe uma mensagem de erro e sai do script.
+ definir_variaveis
Esta função define as variáveis **intervalo** e **duracao** com base nos parâmetros de entrada do script. Se os parâmetros não forem especificados corretamente, a função exibe uma mensagem de erro e sai do script.
+ definir_interface
Esta função define o nome da interface de rede a ser monitorada. Por padrão, o script usa a interface **"eth0"**, mas o usuário pode alterá-la editando o script.
+ criar_arquivo
Esta função cria o arquivo *file.dat* ou limpa o conteúdo se o arquivo já existir. O arquivo é usado para armazenar as informações de vazão lidas pelo script.
+ ler_vazao
Responsável por realizar a leitura do arquivo "/proc/net/dev" e calcular a vazão de download e upload da rede. Em primeiro lugar, é feita a leitura do arquivo utilizando o comando *cat* e o resultado é armazenado em uma variável chamada "dados". Em seguida, é utilizado o comando *grep* para buscar as linhas do arquivo que contém as informações de download e upload da rede. Essas linhas são armazenadas nas variáveis "download" e "upload", respectivamente. As informações de download e upload são extraídas das variáveis utilizando o comando *awk*. As colunas relevantes são a segunda e a décima, que correspondem, respectivamente, ao número de bytes recebidos e ao número de bytes enviados.
A vazão de download e upload é calculada dividindo-se a diferença entre os valores atuais e os valores anteriores pelo tempo decorrido entre as leituras. Esses valores são armazenados nas variáveis "vazao_download" e "vazao_upload", respectivamente. Por fim, a função retorna os valores de vazão de download e upload em bytes por segundo, na forma de uma string com os dois valores separados por uma vírgula.

## Gerando o gráfico com o gnuplot
Para a criação do gráfico com o Gnuplot, é utilizado o comando *gnuplot -persist*. O parâmetro *-persist* é utilizado para manter a janela do Gnuplot aberta após a geração do gráfico, permitindo a sua visualização. Em seguida, são utilizados os comandos específicos do Gnuplot para configurar a aparência do gráfico, como *set title*, *set xlabel* e *set ylabel*, que definem respectivamente o título, o label do eixo x e o label do eixo y.

O comando *plot* é utilizado para plotar os dados no gráfico, e seus parâmetros incluem o arquivo de dados a ser utilizado, a definição do tipo de gráfico (nesse caso, "lines") e a configuração da legenda.

Por fim, é utilizado o comando *quit* para fechar a janela do Gnuplot.

Além disso, é importante ressaltar que o script inclui tratamento de erros, como a verificação da existência do arquivo "file.dat" e a validação dos parâmetros de tempo de leitura e duração do monitoramento.

## Licença
GNU
