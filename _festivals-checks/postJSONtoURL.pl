#!/usr/bin/perl 

use warnings;
use strict;

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common; # Use HTTP::Request directly for more control
use JSON; # For encoding Perl data structures to JSON

use Data::Dump qw(dump);

my $url = 'https://festivals-fileserver:1910/images/upload';
my $file = 'postJSONtoURL.pl';
my $JWT = get_jwt_from_festivals();

my $response = post_file_to_url( $file, $url, $JWT );

print $response, "\n";

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


sub post_json_to_url {

    my $url = 'https://festivals-fileserver:1910/files';
    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts ( SSL_ca_file =>  '/usr/local/festivals-checks/ca.crt',
                    SSL_cert_file => '/usr/local/festivals-checks/api-client.crt',
                    SSL_key_file => '/usr/local/festivals-checks/api-client.key');

    my $data = {
        image => 'fileserver-check.sh',
    };

    my $json_content = encode_json($data); # Encode the Perl hash to JSON

    my $request = HTTP::Request->new(POST => $url);
    $request->header('Content-Type' => 'application/json',
                    'Api-Key' => 'TEST_API_KEY_001');
    $request->content($json_content);

    my $response = $ua->request($request);

    if ($response->is_success) {
        print "JSON POST successful!\n";
        print "Response: " . $response->decoded_content . "\n";
    } else {
        print "JSON POST failed: " . $response->status_line . "\n";
    }

}__END__
Exampleof file upload
Search : lwp useragent upload file
---
#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common; # Provides POST, PUT, etc.

my $ua = LWP::UserAgent->new;
my $upload_url = 'http://example.com/upload'; # Replace with your upload URL
my $local_file_path = 'my_file.txt'; # Replace with the path to your local file

sub post_file_to_url {
    my ( $file, $url, $jwt ) = @_;
}

# Ensure the file exists before attempting to upload
die "File not found: $local_file_path" unless -e $local_file_path;

my $response = $ua->post(
    $upload_url,
    Content_Type => 'form-data',
    Content => [
        file_field_name => [$local_file_path], # 'file_field_name' is the name of the file input field on the server
        # You can add other form fields here if needed:
        # other_field => 'some_value',
    ],
);

if ($response->is_success) {
    print "File uploaded successfully!\n";
    print $response->decoded_content;
} else {
    print "File upload failed: " . $response->status_line . "\n";
    print $response->decoded_content if $response->decoded_content;
}