#!/usr/bin/perl
use strict;
use Tie::IxHash;
use LWP::Simple;

# Cordoba = 04
my $provincia = '04';

my $urlBase = 'http://resultados.gob.ar/99/resu/content/telegramas';

my %circuitos = ();
tie %circuitos, "Tie::IxHash";

mkdir("./html");

my $urlFile = '/IMUN'.$provincia.'.htm';
if (! -f 'html/'.$urlFile) {
    my $url = join('/', $urlBase, $urlFile);
    my $status = getstore($url, 'html/'.$urlFile);
    print "Página $urlFile no existe\n." unless is_success($status);
}

open (URL, 'html/'.$urlFile);
while (<URL>) {
    chomp;
    if ($_ =~ /target="circuitos"/) {
        (my $s) = ($_ =~ /target=\"circuitos\"  >([^\s]*)/);
        $s = sprintf("%03d", $s);
        $circuitos{$s} = ();
    }
}
close(URL);

# Lista de Circuitos
foreach my $s (keys %circuitos) {
    my $urlFile = '/ICIR'.$provincia.$s.'.htm';
    if (! -f 'html/'.$urlFile) {
        my $url = join('/', $urlBase, $urlFile);
        my $status = getstore($url, 'html/'.$urlFile);
        print "Página $urlFile no existe\n." unless is_success($status);
    }

    open (URL, 'html/'.$urlFile);
    while (<URL>) {
        chomp;
        if ($_ =~ /target="mesas"/) {
            (my $m) = ($_ =~ /target=\"mesas\"  >([^\<]*)/);
            push(@{$circuitos{$s}}, $m);
        }
    }
    close(URL);

}


foreach my $seccion (keys %circuitos) {
    print "Seccion: $seccion\n";
    my @a = sort(@{$circuitos{$seccion}});
    @{$circuitos{$seccion}} = @a;
    foreach my $circuito (@{$circuitos{$seccion}}) {
        print "\tCircuitos: $circuito\n";

        my $urlFile = 'IMES'.$provincia.$seccion.$circuito.'.htm';
        # Si no existe el archivo, lo baja
        if (! -f 'html/'.$urlFile) {
            my $url = join('/', $urlBase, $urlFile);
            my $status = getstore($url, 'html/'.$urlFile);
            print "Página $urlFile no existe. URL: $url\n." unless is_success($status);
        }

        # Si existe, lo parsea y baja los pdf
        if (-f 'html/'.$urlFile) {
            open (URL, 'html/'.$urlFile);
            while (<URL>) {
                chomp;
                if ($_ =~ /\<li\>\<a href=/) {
                    (my $filename) = ($_ =~ /a href=\"[^\/]*\/[^\/]*\/[^\/]*\/([^\.]*)./);
                    $filename = $filename.'.pdf';
                    $filename = join('/', $provincia, $seccion, $circuito, $filename);

                    mkdir($provincia);
                    mkdir($provincia.'/'.$seccion);
                    mkdir($provincia.'/'.$seccion.'/'.$circuito);

                    my $url = join('/', $urlBase, $filename);
                    if (! -f $filename) {
#                        print "$url.";
                        my $status = getstore($url, $filename);
                        if (is_success($status)) {
                            print "Bajando archivo $url";
                        } else {
                            print "Archivo $url no existe en el sitio";
                        }


#                        print " Archivo aún no está cargado." unless is_success($status);

                        print "\n";
                    }
                }
            }
            close (URL);
        }



    }
    print "\n";
}


# Ejemplos de enlaces
# http://resultados.gob.ar/99/resu/content/telegramas/IMES040260372A.htm
# http://resultados.gob.ar/99/resu/content/telegramas/04/001/0001/040010001_00003.pdf
# http://resultados.gob.ar/99/resu/content/telegramas/04/001/0012F/040010012F02360.pdf
# http://resultados.gob.ar/99/resu/content/telegramas/04/026/0402/040260402_08645.pdf
