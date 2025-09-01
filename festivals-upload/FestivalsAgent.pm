package FestivalsAgent;

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common; # Use HTTP::Request directly for more control
use JSON; # For encoding Perl data structures to JSON
use Cwd;

use Data::Dump qw(dump);

sub new{
    my ($class, $endpoint) = @_;
    my $pwd = cwd();
    my $self = {
        gateway => 'https://gateway.' . $endpoint,
        discovery => 'https://discovery.' . $endpoint,
        api => 'https://api.' . $endpoint,
        files => 'https://files.' . $endpoint,
        JWT => _get_jwt_from_festivals(),
        SSL_ca_file =>  $pwd . '/ca.crt',
        SSL_cert_file => $pwd . '/api-client.crt',
        SSL_key_file => $pwd . '/api-client.key',
        user_id => 'admin@mail.com',
        password => 'we4711',
        api_key => 'TEST_API_KEY_001'

    };
    bless $self, $class;
    return $self;
}

sub post_location {
    my $self = shift;
    my $location = shift;
    my $endpoint = $self->{api} . '/locations';

    my %dbLocation;
    while( my ( $k, $v) = each %$location ) {
        $dbLocation{'location_'.lc($k)} = $v
    };
    #print 'DBLOCATION: ', dump(%dbLocation), "\n";

    my $response = _modify_hash_for_url( $self, 'POST', \%dbLocation, $endpoint );
    #print 'LOCATION response: ',dump($response), "\n";
    return $response;
}

sub get_info {
    my $self = shift;
    my $endpoint = $self->{gateway} . '/info';

    my $info = _get_url( $self, $endpoint );
    return $info;
}

sub _get_jwt_from_festivals {
    my $jwt = `docker exec -it festivals-checks /home/build/getJWT-check.sh`;
    #print $jwt. "\n";
    return $jwt;
}

sub _get_url{
    my ( $self, $url ) = @_;

    my $request = GET $url;
    $request->header('Api-Key' => 'TEST_API_KEY_001');
    $request->header( 'Authorization' => 'Bearer ' . $self->{JWT} );

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  $self->{SSL_ca_file},
                    SSL_cert_file => $self->{SSL_cert_file},
                    SSL_key_file => $self->{SSL_key_file});

    my $response = $ua->request($request);
    return $response->content;
}

sub _modify_hash_for_url {
    my ( $self, $method, $hash, $url ) = @_;
    
    my $jsonContent = encode_json($hash); # Encode the Perl hash to JSON
    $jsonContent =~ s!\"true\"!true!g;
    $jsonContent =~ s!\"false\"!false!g;
    
    my $request = HTTP::Request->new( 
                  $method, $url,
                  ['Content-Type', 'application/json',
                  'Api-Key', 'TEST_API_KEY_001',
                  'Authorization', 'Bearer ' . $self->{JWT}],
                  $jsonContent);

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  $self->{SSL_ca_file},
                    SSL_cert_file => $self->{SSL_cert_file},
                    SSL_key_file => $self->{SSL_key_file});
   
    my $response = $ua->request($request);
    #print dump($response), "\n";
    return decode_json($response->decoded_content);

    exit;

    if ($response->is_success) {
        print "JSON POST successful!\n";
        print "Response: " . $response->decoded_content . "\n";
    } else {
        print "JSON POST failed: " . $response->status_line . "\n";
    }

}


1;
