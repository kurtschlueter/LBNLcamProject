str = 'Camera1_20100101_000000_RF_2_RO_10';
expressionInBetween = '_[0123456789]+_';
expressionSplit = '_';
expressionMatch = '\d{6,6}';
regInBetween = regexp(str,expressionInBetween)
regSplit = regexp(str,expressionSplit,'split')
regMatch = regexp(str,expressionMatch,'match')

%Find words that start with c, end with t, and contain one or more vowels between them.
str = 'bat cat can car coat court CUT ct CAT-scan';
expression = 'c[aeiou]+t';
startIndex = regexp(str,expression)

%Capture words within a string that contain the letter x.
str = 'EXTRA! The regexp function helps you relax.';
expression = '\w*x\w*';
matchStr = regexp(str,expression,'match')

%Split a string into several substrings, where each substring is delimited by a ^ character.
str = ['Split ^this string into ^several pieces'];
expression = '\^';
splitStr = regexp(str,expression,'split')

%Capture parts of a string that match a regular expression using the 'match' keyword,
%and the remaining parts that do not match using the 'split' keyword.
str = 'She sells sea shells by the seashore.';
expression = '[Ss]h.';
[match,noMatch] = regexp(str,expression,'match','split')