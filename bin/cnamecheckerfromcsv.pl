use strict;
#this file checks the cnames for the domains you have provides in a csv against the cname you want to check
#e.g. perl  cnameCheckerFromCSV.pl domainsforcnamecheck.csv  univision-web-2 where
#the script checks whether  the cname matches the cname you provide from command line 

my $file=$ARGV[0] or die "Need to get CSV file on the command line\n";
my $cmdCname=$ARGV[1] or die "Provide the cname  you are trying to match";
open (INPUT,$file) or die "Cannot open $file";
#Read the domains and name servers form csv file
while(my $line=<INPUT>){
    #printing  the line for now
    chomp($line);
      my $digResult=do_dig($line,"cname");
      #cname index check to see if the cnames match
      if(index($digResult,$cmdCname)!=-1){

        print "$line domain successfully cutover   $digResult"."\n";
      }else{
        print "$line domain not cutover yet $digResult"."\n";
      }
  }



  #Subroutine to do a dig and return the result
  sub do_dig(){
    my($domain,$digType)=@_;
    #Running a dig command to  get response from  nameserver and domains gathering a record, exchange ,cname and
    my $result=`dig +nocmd +nocomments  $digType +short   "$domain." `;
  #  print "dig +nocmd +nocomments  $digType  +short   $domain."."\n" ;
    return $result;
  }
