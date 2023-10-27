-- create the table
CREATE OR REPLACE TABLE sentence_comparison(sentence_1 VARCHAR, sentence_2 VARCHAR);

-- load some data
INSERT INTO sentence_comparison (sentence_1, sentence_2) VALUES
('The cat sat on the', 'The cat sat on thee'),
('Rainbows appear after rain', 'Rainbows appears after rain'),
('She loves chocolate chip cookies', 'She love chocolate chip cookies'),
('Birds fly high in the', 'Birds flies high in the'),
('The sun sets in the', 'The sun set in the'),
('I really like that song', 'I really liked that song'),
('Dogs are truly best friends', 'Dogs are truly best friend'),
('Books are a source of', 'Book are a source of'),
('The moon shines at night', 'The moons shine at night'),
('Walking is good for health', 'Walking is good for the health'),
('Children love to play', 'Children love to play'),
('Music is a universal language', 'Music is a universal language'),
('Winter is coming soon', 'Winter is coming soon'),
('Happiness is a choice', 'Happiness is a choice'),
('Travel broadens the mind', 'Travel broadens the mind'),
('Dogs are our closest companions', 'Cats are solitary creatures'),
('Books are portals to new worlds', 'Movies depict various realities'),
('The moon shines brightly at night', 'The sun blazes hotly at noon'),
('Walking is beneficial for health', 'Running can be hard on knees'),
('Children love to play outside', 'Children love to play'),
('Music transcends cultural boundaries', 'Music is a universal language'),
('Winter is cold and snowy', 'Winter is coming soon'),
('Happiness comes from within', 'Happiness is a choice'),
('Traveling opens up perspectives', 'Travel broadens the mind');

select * from sentence_comparison;

-- compute the JAROWINKLER_SIMILARITY between each pair of sentences
-- The function returns an integer between 0 and 100, where 0 indicates no similarity and 100 indicates an exact match.
select sentence_1, sentence_2, JAROWINKLER_SIMILARITY(sentence_1, sentence_2) as score
from sentence_comparison 
order by 3 desc;
