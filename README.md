# Tarea 3: Análisis Lingüístico Offline con Hadoop y Pig

Este proyecto implementa un sistema de procesamiento Batch utilizando Docker, Hadoop y Apache Pig para analizar comparativamente el vocabulario entre humanos (Yahoo Answers) y una IA (LLM).

## Integrantes
- Samuel Collao

## Requisitos
- Docker y Docker Compose instalados.
- Linux

## Estructura del Proyecto
- \`data/\`: Contiene los datasets y stopwords.
- \`scripts/\`: Scripts de preparación (Python) y análisis (Pig).
- \`docker-compose.yml\`: Orquestación del cluster Hadoop.
- \`run_system.sh\`: Script maestro para ejecución automática.

## Instrucciones de Despliegue

1. Clonar el repositorio:

   git clone https://github.com/SamuelCollao/Tarea-3-SSDD.git
   cd Tarea-3-SSDD

2. Colocar el dataset:
   Asegúrate de que el archivo \`test.csv\`\ esté en la carpeta \`data/\`.

3. Dar permisos de ejecución:

   chmod +x run_system.sh


4. Ejecutar el sistema:

   ./run_system.sh

   *El proceso tomará unos minutos mientras levanta Hadoop y procesa los datos.*

## Resultados
Los resultados (Top 10 palabras) se mostrarán en la terminal al finalizar la ejecución.
