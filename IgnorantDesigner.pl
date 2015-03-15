#!/usr/bin/env perl

use Mojolicious::Lite;

plugin 'Config';

require 'lib/data.html';
push @{ app->renderer->classes }, 'Fake';

get '/' => sub {
    my $c = shift;

    $c->stash( pass => $c->config('pass') );

} => 'index';

get $_ for qw(/about /contact);

under '/admin' => sub {
    my $c = shift;

    return undef;
};

get '/' => 'admin/index';

app->start;