stopwords = LOAD '/input/palabra.txt' AS (word:chararray);

yahoo_sucio = LOAD '/input/yahoo/yahoo.csv' USING PigStorage(',') AS (id:int, tittle:chararray, question:chararray, answer:chararray);

yahoo_limpio= FOREACH yahoo_sucio GENERATE REPLACE(LOWER(answer), '[^a-z0-9\\s]', '') AS text;

yahoo_tokens = FOREACH yahoo_limpio GENERATE FLATTEN(TOKENIZE(text)) AS word;

yahoo_valido = FILTER yahoo_tokens BY SIZE(word) > 2;
yahoo_junto = JOIN yahoo_valido BY word LEFT OUTER, stopwords BY word;
yahoo_final = FILTER yahoo_junto BY stopwords::word IS NULL;

yahoo_grpd = GROUP yahoo_final BY yahoo_valido::word;
yahoo_count = FOREACH yahoo_grpd GENERATE group AS word, COUNT(yahoo_final) AS count;
yahoo_sorted = ORDER yahoo_count BY count DESC;


llm_sucio = LOAD '/input/llm/llm.csv' USING PigStorage(',') AS (id:int, tittle:chararray, question:chararray, answer:chararray);

llm_limpio = FOREACH llm_sucio GENERATE REPLACE(LOWER(answer), '[^a-z0-9\\s]', '') AS text;
llm_tokens = FOREACH llm_limpio GENERATE FLATTEN(TOKENIZE(text)) AS word;
llm_valido = FILTER llm_tokens BY SIZE(word) > 2;
llm_joined = JOIN llm_valido BY word LEFT OUTER, stopwords BY word;
llm_final = FILTER llm_joined BY stopwords::word IS NULL;

llm_grpd = GROUP llm_final BY llm_valido::word;
llm_count = FOREACH llm_grpd GENERATE group AS word, COUNT(llm_final) AS count;
llm_sorted = ORDER llm_count BY count DESC;


rmf /output/yahoo_results;
rmf /output/llm_results;

STORE yahoo_sorted INTO '/output/yahoo_results' USING PigStorage(',');
STORE llm_sorted INTO '/output/llm_results' USING PigStorage(',');