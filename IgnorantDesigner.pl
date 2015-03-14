#!/usr/bin/env perl

use Mojolicious::Lite;

require 'lib/data.html';
push @{ app->renderer->classes }, 'Fake';

get '/' => sub {
    my $c = shift;

} => 'index';

get $_ for qw(/about /contact);

under '/admin' => sub {
    my $c = shift;

    return 1
        if $c->req->url->to_abs->userinfo eq 'Bender:rocks';

    $c->res->headers->www_authenticate('Basic');
    $c->render(text => 'Authentication required!', status => 401);

    return undef;
};

get '/' => 'admin/index';

app->start;