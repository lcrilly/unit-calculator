use strict;

use JSON;
use Plack;
use Plack::Request;

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $body = $req->content;
    my $json = decode_json($body);

    my $r = {
        "result" => 1 / $json->{'operand'},
    };

    my $res = $req->new_response(200);
    my $json = JSON->new();
    $res->body($json->utf8->pretty->encode($r));

    return $res->finalize();
};
