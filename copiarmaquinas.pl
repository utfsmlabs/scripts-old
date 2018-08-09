#!/usr/bin/perl
use Term::ANSIColor;
use threads;
use threads::shared;
use Thread::Queue;
use Getopt::Std;
use Net::OpenSSH;
sub copiar
{
    #$ssh=Net::OpenSSH->new("$_[0].inf.santiago.usm.cl",qw(user root,UserKnownHostsFile /dev/null,StrictHostKeyChecking no));
    $ssh=Net::OpenSSH->new("root\@$_[0].inf.santiago.usm.cl",master_opts =>[-o => "StrictHostKeyChecking=no"]);
    #$ssh1=Net::OpenSSH->new("$_[1].inf.santiago.usm.cl",qw(user root,UserKnownHostsFile /dev/null,StrictHostKeyChecking no));
    $ssh1=Net::OpenSSH->new("root\@$_[1].inf.santiago.usm.cl",master_opts =>[-o => "StrictHostKeyChecking=no"]);
    if ($options{s})
    {
        if ($ssh1->system("lvremove $options{s} -f")) 
        {
            print color("green"), "se borro el snap $options{s} en $_[1]\n",color("reset");
            print LOG "[LOG] se borro el snap en $options{s} en $_[1]\n";
        }
        else
        {
            print color("yellow"),"ocurrio un error al borrar el snap en $_[1]\n",color("reset");
            print LOG "[WARN] ocurrio un error al borrar el snap en $_[1]\n";
        }
    }
    print color("green"),"copiando del $_[0] al $_[1]\n",color("reset");
    #print LOG "[LOG] copiando del $_[0] al $_[1]\n";
    if ($ssh->system("dd if=$options{l} bs=8k | ssh root\@$_[1] \"cat > $options{l}\""))
    {
        print LOG "[LOG] copiado exitoso al $_[1]\n";
        if ($options{s})
        {
            print color("green"),"creando Snapshot en $_[1]\n",color("reset");
            @snappath=split("\/",$options{s});
            $ssh1->system("lvcreate -L 5G -n $snappath[3] -s $options{l}");
            print LOG "[LOG] Snapshot creado en $_[1]\n";
            #print "corrigiendo permisos en $_[1]\n";
            #$ssh1->system("/etc/VirtualBox/permisos.sh");
        }
        undef $ssh;
        undef $ssh1;
        $q->enqueue($_[0],$_[1]);
        return;
    }
    else
    {
        print color("black on_red blink"),"Fallo la copia del $_[0] al $_[1]\n",color("reset");
        print LOG "[ERROR] Fallo la copia del $_[0] al $_[1]\n";
        $q->enqueue($_[0]);
        undef $ssh;
        undef $ssh1;
        return;
    }
}
getopts("hs:f:l:"=>\%options);
if ($options{h})
{
    die "$0 [opciones]\n-h este help\n-f archivo de los hosts (el primero debe contener la imagen original a replicar)\n-l ruta del lv\n-s ruta del snapshot\n"; 
}
if (!$options{l})
{
    die "falta la ruta del LV \nusa: $0 -h\n";
}
open(PCS,"<$options{f}") or die("no esta el archivo con los hosts usa $0 -h\n");
open(LOG,">copiado.log");
while (<PCS>)
{
    chomp;
    push(@pendientes,$_);
}
$q = Thread::Queue->new();
$q->enqueue(shift @pendientes);
while (@pendientes){
    while($q->pending()) 
    {
        my $usar=$q->dequeue();
        @args=($usar,shift @pendientes);
        if(defined($args[1]))
        {
            share($options{s});
            share($options{f});
            share($options{l});
            push(@thrs,threads->new(\&copiar,@args));
        }   
    }
    for (@thrs)
    {
        $_->join();
    }
    @thrs=();
}
close(PCS);
close(LOG);
