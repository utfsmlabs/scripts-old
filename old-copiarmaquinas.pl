#!/usr/bin/perl
use threads;
use threads::shared;
use Thread::Queue;
my @usable : shared;
my @pendientes : shared;
my @threads;
use Net::OpenSSH;
sub copiar
{
    $ssh=Net::OpenSSH->new("$_[0].inf.santiago.usm.cl",qw(user root));
    $ssh1=Net::OpenSSH->new("$_[1].inf.santiago.usm.cl",qw(user root));
    if ($ssh1->system("lvremove storage/windows-snap -f")) 
    {
        print "se borro el snap en $_[1]\n";
    }
    else
    {
        print "ocurrio un error al borrar el snap en $_[1]\n";
    }
    print "copiando del $_[0] al $_[1]\n";
    if ($ssh->system("dd if=/dev/storage/windows bs=8k | ssh root\@$_[1] \"cat > /dev/storage/windows\""))
    {
        print "creando Snapshot en $_[1]\n";
        $ssh1->system("lvcreate -L 5G -n windows-snap -s storage/windows");
        print "corrigiendo permisos en $_[1]\n";
        $ssh1->system("/etc/VirtualBox/permisos.sh");
        undef $ssh;
        undef $ssh1;
        $q->enqueue($_[0],$_[1]);
        return;
    }
    else
    {
        print "Fallo la copia del $_[0] al $_[1]\n";
        $q->enqueue($_[0]);
        undef $ssh;
        undef $ssh1;
        return;

    }
    #($output,$error,$exit)=$ssh->system("touch asdf && exit");
    #undef $ssh;
    #print "copiar del $_[0] al $_[1]\n";
    #$q->enqueue($_[0],$_[1]);
    #print "se encolaron los elementos $_[0] y $_[1]\n";
}
open(PCS,"<$ARGV[0]") or die("no esta el archivo con los hosts");
while (<PCS>)
{
    chomp;
    push(@pendientes,$_);
}
#if (is_shared(@usable)) {
#        print "esta compartida la wea";
#}
#for (@pendientes){
#    print;
#}
#push(@usables,shift @pendientes);
$q = Thread::Queue->new();
$q->enqueue(shift @pendientes);
while (@pendientes){
    while($q->pending()) 
    {
        my $usar=$q->dequeue();
        #print "inicio del while con ".$usar."\n";
        @args=($usar,shift @pendientes);
        if(defined($args[1]))
        {
            #print $args[0]." y ".$args[1]."\n";
            push(@thrs,threads->new(\&copiar,@args));
            #threads->new(\&copiar,@args);
        }   
        #print "fin del while con ".$args[1]."\n";
    }
    for (@thrs)
    {
        #print "se saco un thread de la cola\n";
        $_->join();
        #pop(@thrs);
    }
    @thrs=();
}

