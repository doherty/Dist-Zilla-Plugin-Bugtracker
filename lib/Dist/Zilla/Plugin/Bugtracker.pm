use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Bugtracker;

# ABSTRACT: Automatically sets the bugtracker URL
use Moose;
with 'Dist::Zilla::Role::MetaProvider';

use MooseX::Types::URI qw[Uri];

has web => (
    is  => 'ro',
    isa => Uri,
    coerce => 1,
    default => 'http://rt.cpan.org/Public/Dist/Display.html?Name=%s',
);

has mailto => (
    is  => 'ro',
    isa => 'Str',
);

sub metadata {
    my $self = shift;

    my $web;
    my $mailto;
    my $ret;
    if ($self->web) {
        if ($self->web->as_string eq 'http://rt.cpan.org/Public/Dist/Display.html?Name=%s') {
            $ret->{'resources'}->{'bugtracker'}->{'web'}    = sprintf($self->web->as_string, $self->zilla->name);
            $ret->{'resources'}->{'bugtracker'}->{'mailto'} = sprintf('bug-%s at rt.cpan.org', lc($self->zilla->name));
        }
        else {
            $ret->{'resources'}->{'bugtracker'}->{'web'}    = $self->web->as_string;
        }
    }
    $ret->{'resources'}->{'bugtracker'}->{'mailto'} = $self->mailto if $self->mailto;

    return $ret;
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=for test_synopsis
1;
__END__

=head1 SYNOPSIS

In C<dist.ini>:

    [Bugtracker]

=head1 DESCRIPTION

This plugin sets the distribution's bugtracker URL as metadata. This plugin
assumes you are using the CPAN RT bugtracker and sets those 2 fields:

  web = http://rt.cpan.org/Public/Dist/Display.html?Name=$dist
  mailto = bug-$dist at rt.cpan.org

Please see L<CPAN::Meta::Spec|http://search.cpan.org/dist/CPAN-Meta/lib/CPAN/Meta/Spec.pm#resources>
for more information.

=function metadata

Sets the bugtracker URL in the distribution's metadata.

=cut
