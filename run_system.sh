#!/bin/bash

echo "=== 1. LIMPIANDO DOCKER  ==="

docker-compose down -v --remove-orphans 2>/dev/null

echo "=== 2. INICIANDO SERVICIOS ==="
docker-compose up -d --build

echo "=== 3. GENERANDO DATOS ==="

sleep 10
docker exec pig-client python3 /app/scripts/prepare_data.py

echo "=== 4. ESPERANDO A HADOOP (120 SEGUNDOS) ==="
sleep 60

NAMENODE_STATUS=$(docker inspect -f '{{.State.Running}}' namenode 2>/dev/null)

if [ "$NAMENODE_STATUS" != "true" ]; then
    echo "¡ERROR CRÍTICO! El Namenode se ha detenido."
    echo "--- LOGS DEL NAMENODE (Para depurar) ---"
    docker logs namenode | tail -n 20
    echo "----------------------------------------"
    exit 1
else
    echo "Namenode sigue corriendo. Esperando 60 segundos más para Safemode..."
    sleep 60
fi

echo "=== 5. PREPARANDO HDFS ==="
docker exec pig-client hadoop fs -mkdir -p /input/yahoo
docker exec pig-client hadoop fs -mkdir -p /input/llm

echo "=== 6. SUBIENDO DATOS ==="
docker exec pig-client hadoop fs -put /app/data/yahoo.csv /input/yahoo/
docker exec pig-client hadoop fs -put /app/data/llm.csv /input/llm/
docker exec pig-client hadoop fs -put /app/data/palabra.txt /input/

echo "=== 7. EJECUTANDO PIG ==="
docker exec pig-client pig -x mapreduce /app/scripts/analisis.pig

echo " "
echo "=== RESULTADOS FINALES ==="
echo "--- HUMANOS ---"
docker exec pig-client hadoop fs -cat /output/yahoo_results/part-r-00000 2>/dev/null | head -n 10
echo " "
echo "--- IA (LLM) ---"
docker exec pig-client hadoop fs -cat /output/llm_results/part-r-00000 2>/dev/null | head -n 10

sudo chown -R $USER:$USER data/ 2>/dev/null