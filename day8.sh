input="Sources/AOC2015Core/Inputs/input_8_1.txt"
while IFS= read -r line
do
  echo "$line"
  echo ${#line}
  echo $line | xargs
  echo $line | sed "s/\\\"//g"
done < "$input"