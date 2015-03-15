#!/usr/bin/env perl

use Mojolicious::Lite;
use lib qw{lib};
use IgnorantDesigner::Model::Users;
plugin 'Config';

require 'lib/data.html';
push @{ app->renderer->classes }, 'Fake';

#### HELPERS

helper users => sub {
    my $c = shift;

    state $users = IgnorantDesigner::Model::Users->new(
        admin_pass_hash => $c->config('admin_pass'),
        admin_user_hash => $c->config('admin_user'),
    );

    return $users;
};

#### ROUTES

get '/' => sub {
    my $c = shift;

} => 'index';

get $_ for qw(/about /contact);

get '/login' => sub {
    my $c = shift;
    $c->redirect_to('admin/index')
        if $c->session('logged_in');
};

post '/login' => sub {
    my $c = shift;

    if ( $c->users->check( $c->param('user'), $c->param('password') ) ) {
        $c->session( logged_in => 1 );
        $c->redirect_to('admin/index');
    }
    else {
        $c->stash( login_failed => 1 );
    }
};

under '/admin' => sub {
    my $c = shift;

    return 1 if $c->session('logged_in');
    return $c->redirect_to('/login');
};

get '/' => 'admin/index';

app->start;