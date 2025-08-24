#!/usr/bin/perl 

use warnings;
use strict;

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common; # Use HTTP::Request directly for more control
use JSON; # For encoding Perl data structures to JSON

use Data::Dump qw(dump);

my $url = 'https://festivals-fileserver:1910/images/upload';
my $file = 'postJSONtoURL.pl';
my $JWT = get_jwt_from_festivals();

my $response = modify_hash_for_url(
    'PATCH',
    { 'festival_name' => 'nff2025' },
    'https://festivals-server:10439/festivals/3',
    $JWT);

#my $response = post_file_to_url( $file, $url, $JWT );

#print $response, "\n";

sub get_jwt_from_festivals {
    my $url = 'https://festivals-identity-server:22580/users/login';

    my $request = GET $url;
    $request->authorization_basic('admin@email.com', 'we4711');
    $request->header('Api-Key' => 'TEST_API_KEY_001');

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  '/usr/local/festivals-checks/ca.crt',
                    SSL_cert_file => '/usr/local/festivals-checks/api-client.crt',
                    SSL_key_file => '/usr/local/festivals-checks/api-client.key');

    my $response = $ua->request($request);

    return $response->content;
}

sub post_file_to_url {
    my ( $file, $url, $JWT ) = @_;

    my $request = POST  $url,
                  'Content-Type' => 'multipart/form-data',
                  'Api-Key' => 'TEST_API_KEY_001',
                  Authorization => "Bearer $JWT",
                  Content => ['image' => ["$file"]];

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  '/usr/local/festivals-checks/ca.crt',
                    SSL_cert_file => '/usr/local/festivals-checks/api-client.crt',
                    SSL_key_file => '/usr/local/festivals-checks/api-client.key');

    my $response = $ua->request($request);
    return $response->content;    
}


sub modify_hash_for_url {
    my ( $method, $hash, $url, $JWT ) = @_;
    
    my $jsonContent = encode_json($hash); # Encode the Perl hash to JSON

    my $request = HTTP::Request->new( 
                  $method, $url,
                  ['Content-Type', 'application/json',
                  'Api-Key', 'TEST_API_KEY_001',
                  'Authorization', "Bearer $JWT"],
                  $jsonContent);

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  '/usr/local/festivals-checks/ca.crt',
                    SSL_cert_file => '/usr/local/festivals-checks/api-client.crt',
                    SSL_key_file => '/usr/local/festivals-checks/api-client.key');

   
    my $response = $ua->request($request);

    print dump($response), "\n";
    exit;

    if ($response->is_success) {
        print "JSON POST successful!\n";
        print "Response: " . $response->decoded_content . "\n";
    } else {
        print "JSON POST failed: " . $response->status_line . "\n";
    }

}__END__
