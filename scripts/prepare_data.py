import csv
import random
import os
import sys

input_file = '/app/data/test.csv'
local_input_file = 'data/test.csv'
output_yahoo = 'data/yahoo.csv'
output_llm = 'data/llm.csv'
LIMIT_ROW = 5000

ai_vocabulary = [
    "context", "model", "language", "processing", "information", 
    "user", "efficient", "algorithm", "summary", "assistant", 
    "framework", "deployment", "optimization", "data", "driven"
]

connectors = [
    "it is important to note", 
    "regarding the query", 
    "consequently", 
    "based on the analysis",
    "furthermore",
    "typically"
]

def get_input_path():
    if os.path.exists(input_file): return input_file
    if os.path.exists(local_input_file): return local_input_file
    return None

def generar_respuestas_llm():
    return "As an AI model, {} that {} is key.".format(random.choice(connectors), random.choice(ai_vocabulary))

def main():
    path = get_input_path()

    if not path:
        print("Error: Input file does not exist.")
        return
    
    print("Reading input file...")

    try:
        with open(path, 'r', encoding='utf-8',errors='ignore') as f_in, \
             open(output_yahoo, 'w', encoding='utf-8') as f_out_yahoo, \
             open(output_llm, 'w', encoding='utf-8') as f_out_llm:
        
            reader = csv.reader(f_in)
            writer_yahoo = csv.writer(f_out_yahoo)
            writer_llm = csv.writer(f_out_llm)

            count = 0
            rescued = 0
            for row in reader:
                if count >= LIMIT_ROW:
                    break
                if not row:
                    continue

                row_id = row[0] if len(row) > 0 else str(count)
                title = row[1] if len(row) > 1 else "No Title"
                question = row[2] if len(row) > 2 else "No Question"
                if len(row) > 3:
                    text_to_analize = row[3]
                else:
                    text_to_analize = question
                    rescued += 1

                clean_yahoo = text_to_analize.replace(',', '').replace('\n', ' ')
                writer_yahoo.writerow([row_id, title, question, clean_yahoo])

                fake_llm_answer = generar_respuestas_llm()
                writer_llm.writerow([row_id, title, question, fake_llm_answer]) 

                count += 1

            print("Procesadas {} filas.".format(count))
            print("Filas incompletas rescatadas: {}".format(rescued))
        
    except Exception as e:
        print("An error occurred: {}".format(e))
        sys.exit(1)

if __name__ == "__main__":
    main()