package EntityModel::Web;
use EntityModel::Class {
	_isa	=> [qw(EntityModel::Plugin)],
	site	=> { type => 'array', subclass => 'EntityModel::Web::Site' },
};

our $VERSION = '0.001';

=head1 NAME

EntityModel::Web - website support for L<EntityModel>

=head1 VERSION

version 0.001

=head1 SYNOPSIS

=head1 DESCRIPTION

Support for L<EntityModel>-backed websites.

Accepts a definition for site + page hierarchy, and applies handlers as required to convert incoming requests
into outgoing responses.

The following classes provide most of the key functionality:

=over 4

=item * L<EntityModel::Web::Request> - abstraction for an incoming HTTP/HTTPS request, may be subclassed by the
appropriate server layer.

=item * L<EntityModel::Web::Response> - abstraction for outgoing HTTP/HTTPS response

=item * L<EntityModel::Web::Site> - website definition

=item * L<EntityModel::Web::Page> - page definition, specfiying the handlers, templates, data and URL(s) for a specific
page.

=item * L<EntityModel::Web::Context> - active request handler, includes everything appropriate for a single HTTP request.

=item * L<EntityModel::Web::Authorization> - support for authorization on a single request.

=item * L<EntityModel::Web::Authentication> - support for request authentication.

=item * L<EntityModel::Web::Session> - store and retrieve data between requests for a user session

=back

Definitions are stored under the C<web> key as a list of sites:

 web: [
  host: something.com
  page: [
   name: 'Index'
   path: ''
   pathtype: string
   title: 'Index page'
  ]
 ]

=cut

use URI;
use EntityModel::Web::Site;
use EntityModel::Web::Context;
use EntityModel::Template;

=head1 METHODS

=cut

=head2 register

Registers this module as a plugin with the L<EntityModel> main classes.

=cut

sub register {
	my $self = shift;
	my $model = shift;
	$model->provide_handler_for(
		web	=> $self->sap(sub {
			my ($self, $model, %args) = @_;
			$self->site->push(EntityModel::Web::Site->new($_)) for @{$args{data}};
		})
	);
	return $self;
}

=head2 page_from_uri

=cut

sub page_from_uri {
	my $self = shift;
	my $uri = shift;
	my ($site) = grep { $_->host eq $uri->host } $self->site->list;
	return EntityModel::Error->new("No site") unless $site;

	my $page = $site->page_from_uri($uri);
	return EntityModel::Error->new("No page") unless $page;
	return $page;
}

1;

__END__

=head1 AUTHOR

Tom Molesworth <cpan@entitymodel.com>

=head1 LICENSE

Copyright Tom Molesworth 2009-2011. Licensed under the same terms as Perl itself.