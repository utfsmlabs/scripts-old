#!/usr/bin/perl


#use Net::SSH::Perl;
use Net::OpenSSH;

open(LOGINS,"<logins") or die("cago la wea no pille el archivo\n");
open(HOSTS,"<pcs/todos") or die("cago el segundo archivo\n");
while(<LOGINS>){
	chomp;
    $host=<HOSTS>;
    chomp $host;
    if(eof(HOSTS)){
        seek(HOSTS,0,0);
        print "Volviendo al primer pc\n";
        $host=<HOSTS>;
        chomp $host;
    }
	print "Host:$host\n"; 
    %opts = (user => "root", passwd => "AuchentoshAn014");
    eval {
        $ssh=Net::OpenSSH->new("$host.inf.santiago.usm.cl",qw(user root));
        #print "Login pass\n";
        ($output,$errors,$exit) = $ssh->system("su - $_ -c exit");
        print "login as ".$_."\n";
    };
    if ($@){
        print "error en el pc $host\n";
    }
	undef $ssh;
	
}

