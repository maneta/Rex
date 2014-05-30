#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

=head1 NAME

Rex::Commands::Network - Network Module

=head1 DESCRIPTION

With this module you can get information of the routing table, current network connections, open ports, ...

=head1 SYNOPSIS

 use Rex::Commands::Network;
 
 my @routes = route;
 print Dumper(\@routes);
 
 my $default_gw = default_gateway;
 default_gateway "192.168.2.1";
 
 my @netstat = netstat;
 my @tcp_connections = grep { $_->{"proto"} eq "tcp" } netstat;

=head1 EXPORTED FUNCTIONS

=over 4

=cut

package Rex::Commands::Network;

use strict;
use warnings;

require Rex::Exporter;
use Rex::Commands::Run;
use Rex::Commands::Gather;
use Rex::Hardware::Network;
use Data::Dumper;

use vars qw(@EXPORT);
use base qw(Rex::Exporter);

@EXPORT = qw(route default_gateway netstat);

=item route

Get routing information

=cut

sub route {
  return Rex::Hardware::Network::route();
}

=item default_gateway([$default_gw])

Get or set the default gateway.

=cut

sub default_gateway {
  my $gw = shift;

  if ($gw) {
    Rex::get_current_connection()->{reporter}
      ->report_resource_start( type => "default_gateway", name => $gw );

    my $cur_gw = Rex::Hardware::Network::default_gateway();

    Rex::Hardware::Network::default_gateway($gw);

    my $new_gw = Rex::Hardware::Network::default_gateway();

    if ( $cur_gw ne $new_gw ) {
      Rex::get_current_connection()->{reporter}
        ->report( changed => 1, message => "New default gateway $gw set." );
    }

    Rex::get_current_connection()->{reporter}
      ->report_resource_end( type => "default_gateway", name => $gw );
  }

  return Rex::Hardware::Network::default_gateway();
}

=item netstat

Get network connection information

=cut

sub netstat {
  return Rex::Hardware::Network::netstat();
}

=back

=cut

1;
