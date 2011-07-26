package EntityModel::Web::Page::Data::Object;
BEGIN {
  $EntityModel::Web::Page::Data::Object::VERSION = '0.002';
}
use EntityModel::Class {
	_version => '$Rev: 182 $',
	class		=> { type => 'string' },
	instance	=> { type => 'string' },
	method		=> { type => 'string' },
	param		=> { type => 'array', subclass => 'EntityModel::Web::Page::Data::Object::Param' },
};

=pod

=cut

1;

