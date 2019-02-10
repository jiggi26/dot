open(IN,shift); $j=0; $first=1;
while(<IN>){
  if($first) { @s=split(/\s+/,$_); $dim = @s; $first = 0; }
  else {  @s=split(/\s+/,$_); if (@s != $dim) { print "ERROR! dim different at row $j\n"; } }
  $j++;
} close IN;

print "$j $dim\n";

