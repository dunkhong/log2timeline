# array of HexInt32
package Parse::Evtx2::VariantType::Type0x94;
use base qw( Parse::Evtx2::VariantType );

use Carp::Assert;

sub parse_self {
	my $self = shift;
	
	my $start = $self->{'Start'};
	
	my $data;
	assert($self->{'Context'} == 1, "not tested in value context. Please submit a sample.") if DEBUG;
	if ($self->{'Context'} == 1) {
		# context is SubstArray
		# length is predetermined, no length will preceed the data
		assert($self->{'Length'} >= 4, "packet too small") if DEBUG;
		assert($self->{'Length'} % 4 == 0, "unexpected length") if DEBUG;
		$data = $self->{'Chunk'}->get_data($start, $self->{'Length'});
	} else {
		# context is Value
	}
	
	my $i;
	my $elements = $self->{'Length'} / 4;
	my @data;
	for ($i=0; $i<$elements; $i++ ) {
		$data[$i] = sprintf("[%u] 0x%s",
		 	$i,
			scalar reverse unpack("h*", substr($data, $i*4, 4))
		);
	}	
	$self->{'String'} = join("\n", @data);
}

1;
