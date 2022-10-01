lines = LOAD 'eBooks/*.txt' AS (line:chararray);
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line, ' ')) AS word;
grouped = GROUP words BY word;
word_count = FOREACH grouped GENERATE group, COUNT(words) AS count;
frequent_words = FILTER word_count BY count>=48500;
ordered_words = ORDER frequent_words BY $1 DESC;
DUMP ordered_words;





