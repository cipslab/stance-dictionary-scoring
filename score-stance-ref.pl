use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });
my $pass = '((is|are|be|being|was|were|(was|were) being|been|have been|have been being|had been|had been being|(will|shall) be|(will|shall) be being|(will|shall) have been|(would|should) be|(would|should) have been|(would|should) be being)|(would|should) have been being)';
my @rules;
open(IN,"rules.txt") or die "Can't open input: $!\n";
while(<IN>) {
    chop;
    my($n,$evtype,$gramtype,$regex) = split(/\t/);
    push(@rules,$regex);
}
open(OUT,">test-data-scores.txt") or die "Can't open output: $!";
print OUT "type\twords\tstance\tcert\tdoub\tp-stance\tp-cert\tp-doubt\tp-cadv\tp-cverb\tp-cadj\tp-cemp\tp-cpm\tp-dadv\tp-dverb\tp-dadj\tp-dpm\tp-dnm\n";
my @fn = ('p-test-data.csv','np-test-data.csv');
foreach my $texttype (0,1) {
    my $file = $fn[$texttype];
    open(my $fh, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
    while (my $text = $csv->getline ($fh)) {
        $text->[0] =~ s/[\,\.\:\;\(\)\"]/ /g;
        $text->[0] =~ s/\s+/ /g;
        my @temp = split(/\s+/,$text->[0]);
        my $words = @temp;
        if ($words) { 
            my @score;            
            foreach my $i (0..$#rules) {
                while ($text->[0] =~/$rules[$i]/ig) {
                    $score[$i]++;
                }
            }
            my $scoresum = 0;
            my $certainty = 0;
            my $doubt = 0;
            foreach my $i (0..$#score) {
                $scoresum += $score[$i];
                if ($i <= 13) {
                    $certainty += $score[$i];
                }
                else {
                    $doubt += $score[$i];
                }
            }
            my $p_stance = sprintf("%.4f",$scoresum/$words);
            my ($p_certainty,$p_doubt);
            my $cdsum = $certainty + $doubt;
            if ($cdsum) {
                $p_certainty = sprintf("%.4f",$certainty/$cdsum);
                $p_doubt = sprintf("%.4f",$doubt/$cdsum);
            }
            else {
                $p_certainty = $p_doubt = 0;
            }
            
            print OUT "$texttype\t$words\t$scoresum\t$certainty\t$doubt\t$p_stance\t$p_certainty\t$p_doubt\t",prob(\@score,0,2,$words),"\t",prob(\@score,3,9,$words),"\t",prob(\@score,10,11,$words),"\t",prob(\@score,12,12,$words),"\t",prob(\@score,13,13,$words),"\t",prob(\@score,14,14,$words),"\t",prob(\@score,15,20,$words),"\t",prob(\@score,21,23,$words),"\t",prob(\@score,24,24,$words),"\t",prob(\@score,25,25,$words),"\n";
        }
    }
    close $fh;
}
close OUT;

sub prob {
    my ($data,$start,$stop,$words) = @_;
    my $sum = 0;
    foreach my $i ($start..$stop) {
        $sum += $data->[$i];
    }
    return sprintf("%.4f",$sum/$words);
}