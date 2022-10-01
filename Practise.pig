lines = LOAD 'eBooks/*.txt' AS (line:chararray);
words = FOREACH lines GENERATE FLATTEN(TOKENIZE(line, ' ')) as word;
length = FOREACH words GENERATE SIZE(word);
grouped = GROUP length BY $0;
length_count = FOREACH grouped GENERATE group,COUNT(length);
frequent_groups = FILTER length_count BY $1 >= 48500;
ordered_count = ORDER frequent_groups BY $1 DESC;
DUMP ordered_count;


