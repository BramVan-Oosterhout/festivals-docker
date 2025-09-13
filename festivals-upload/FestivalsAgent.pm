package FestivalsAgent;

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common; # Use HTTP::Request directly for more control
use JSON; # For encoding Perl data structures to JSON
use Cwd;
use Try::Tiny;

use Data::Dump qw(dump);

sub new{
    my ($class, $domain) = @_;
    my $pwd = cwd();
    my $self = {
        gateway => 'https://gateway.' . $domain,
        discovery => 'https://discovery.' . $domain,
        api => 'https://api.' . $domain,
        files => 'https://files.' . $domain,
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

sub new_post_object {
    my $self = shift;
    my ($object, $endpoint ) = @_;
    $endpoint = $self->{api} . $endpoint;

    my $response = _modify_hash_for_url( $self, 'POST', $object, $endpoint );
#   print 'Object response: ',dump($response), "\n";
    return $response;
}

sub post_object {
    my $self = shift;
    my ($object, $endpoint, $prefix ) = @_;
    $endpoint = $self->{api} . $endpoint;

    my %dbObject;
    while( my ( $k, $v) = each %$object ) {
        $dbObject{$prefix.lc($k)} = $v
    };
    #print 'DBobject: ', dump(%dbObject), "\n";

    my $response = _modify_hash_for_url( $self, 'POST', \%dbObject, $endpoint );
    #print 'Object response: ',dump($response), "\n";
    return $response;
}

sub post_artist {
    my $self = shift;
    my $artist = shift;
    my $endpoint = $self->{api} . '/artists';

    my %dbartist;
    while( my ( $k, $v) = each %$artist ) {
        $dbartist{'artist_'.lc($k)} = $v
    };
    #print 'DBartist: ', dump(%dbartist), "\n";

    my $response = _modify_hash_for_url( $self, 'POST', \%dbartist, $endpoint );
    #print 'artist response: ',dump($response), "\n";
    return $response;
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

sub get_api_endpoint{
    my $self = shift;
    my ( $endpoint ) = @_;

    my $response_content = _get_url( $self, $self->{api} . $endpoint );
    my $result;
    try {
        #print "I will decode the JSON\n";
        $result = decode_json($response_content);
    } 
    catch  {
        #print "I found an error in the JSON\n";
        return undef;
    } ;
    return $result;
}

sub get_url{
    my $self = shift;
    my ( $endpoint ) = @_;
    
    my $response_content = _get_url( $self, $self->{api} . $endpoint );
    return decode_json($response_content);
}

sub get_info {
    my $self = shift;
    my $endpoint = $self->{gateway} . '/info';

    my $info = _get_url( $self, $endpoint );
    return $info;
}

sub get_jwt_from_festivals {
    my $self = shift;
    my ( $inContainer ) = @_;
    if ($inContainer ) {
        return _get_jwt_from_container($self);
    } else {
        return _get_jwt_from_cli();
    }
}

sub _get_jwt_from_cli {
    my $jwt = `docker exec -it festivals-checks /home/build/getJWT-check.sh`;
    #print $jwt. "\n";
    return $jwt;
}

sub _get_jwt_from_container {
    my $self = shift;
    my $url = 'https://festivals-identity-server:22580/users/login';

    my $request = GET $url;
    $request->authorization_basic('admin@email.com', 'we4711');
    $request->header('Api-Key' => 'TEST_API_KEY_001');

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  $self->{SSL_ca_file},
                    SSL_cert_file => $self->{SSL_cert_file},
                    SSL_key_file =>  $self->{SSL_key_file});

    my $response = $ua->request($request);
    #print 'JWTRESPONSE: ', dump($response), "\n";

    return $response->content;
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
    #print 'GETURL - RESPONSE: ', dump($response), "\n";
    return $response->decoded_content;
}

sub _modify_hash_for_url {
    my ( $self, $method, $hash, $url ) = @_;
    
    my $jsonContent = encode_json($hash); # Encode the Perl hash to JSON
    $jsonContent =~ s!\"true\"!true!g;
    $jsonContent =~ s!\"false\"!false!g;
    $jsonContent =~ s!\"(\d+)\"!$1!g;
    
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
        #print "JSON POST successful!\n";
        #print "Response: " . $response->decoded_content . "\n";
    } else {
        #print "JSON POST failed: " . $response->status_line . "\n";
    }

}


1;
