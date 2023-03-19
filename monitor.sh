#!/bin/bash

# Verifica se o número de parâmetros é válido
if [ $# -ne 2 ]; then
    echo "Uso: $0 <intervalo> <duracao>"
    exit 1
fi

# Lê os parâmetros de intervalo e duração
intervalo=$1
duracao=$2

# Verifica se os parâmetros são números inteiros
if ! [[ "$intervalo" =~ ^[0-9]+$ ]] || ! [[ "$duracao" =~ ^[0-9]+$ ]]; then
    echo "Erro: os parâmetros devem ser números inteiros."
    exit 1
fi

# Verifica se a duração é maior ou igual ao intervalo
if [ $duracao -lt $intervalo ]; then
    echo "Erro: a duração deve ser maior ou igual ao intervalo."
    exit 1
fi

# Obtém o nome da placa de rede
interface=$(ip route get 1 | awk '{print $5;exit}')

echo "Monitorando a rede na interface $interface..."

# Loop principal
for ((i=0; i<$duracao; i+=$intervalo)); do
    # Lê o arquivo /proc/net/dev e obtém a quantidade de bytes recebidos e enviados
    read rx1 tx1 <<<$(awk "/$interface/"'{print $2,$10}' /proc/net/dev)

    # Aguarda o intervalo de tempo
    sleep $intervalo

    # Lê novamente o arquivo /proc/net/dev e obtém a quantidade de bytes recebidos e enviados
    read rx2 tx2 <<<$(awk "/$interface/"'{print $2,$10}' /proc/net/dev)

    # Calcula a quantidade de bytes recebidos e enviados durante o intervalo
    rx_bytes=$(expr $rx2 - $rx1)
    tx_bytes=$(expr $tx2 - $tx1)

    # Calcula a vazão de download e upload em bytes por segundo (B/s)
    rx_rate=$(expr $rx_bytes / $intervalo)
    tx_rate=$(expr $tx_bytes / $intervalo)

    # Imprime a vazão de download e upload na tela
    echo "$(date +%s) $rx_rate $tx_rate" >> file.dat
done

echo "Monitoramento concluído. Gerando gráfico..."

# Gera o gráfico com o gnuplot
gnuplot -persist <<- EOF
set title "Vazão de Download e Upload da Rede"
set xlabel "Tempo (s)"
set ylabel "Vazão (B/s)"
plot "file.dat" using 1 with lines title "Download", "" using 2 with lines title "Upload"
EOF
