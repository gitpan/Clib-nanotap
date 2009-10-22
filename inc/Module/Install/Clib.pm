#line 1
package Module::Install::Clib;
use strict;
use warnings;
our $VERSION = '0.01';
use 5.008_001;
use base qw(Module::Install::Base);
use Config;
use File::Spec;

my $mkpath = q{$(NOECHO) $(ABSPERL) -MExtUtils::Command -e mkpath -- };
my $cp     = q{$(NOECHO) $(ABSPERL) -MExtUtils::Command -e cp     -- };

sub clib_header {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $dstdir = File::Spec->catdir('$(INSTALLARCHLIB)', 'auto', 'Clib', 'include', $distname);
    my $dst = File::Spec->catfile($dstdir, $filename);
    $self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(NOECHO) \$(ECHO) Installing $dst
\t\t$mkpath $dstdir
\t\t$cp "$filename" "$dst"

END_MAKEFILE
}

sub clib_library {
    my ($self, $filename) = @_;
    (my $distname = $self->name) =~ s/Clib-//;

    my $dstdir = File::Spec->catdir('$(INSTALLARCHLIB)', 'auto', 'Clib', 'lib');
    my $dst = File::Spec->catfile($dstdir, $filename);
    $self->postamble(<<"END_MAKEFILE");
config ::
\t\t\$(NOECHO) \$(ECHO) Installing $dst
\t\t$mkpath $dstdir
\t\t$cp "$filename" "$dst"

END_MAKEFILE
}

sub clib_setup {
    my ($self) = @_;
    my @dirs = map { File::Spec->catfile($_, qw/auto Clib/) } grep /$Config{archname}/, @INC;
    my @libs = grep { -d $_ } map { File::Spec->catfile($_, 'lib') }     @dirs;
    my @incs = grep { -d $_ } map { File::Spec->catfile($_, 'include') } @dirs;
    $self->cc_append_to_inc(@incs);
    $self->cc_append_to_libs(@libs);
}

1;
__END__

#line 111
