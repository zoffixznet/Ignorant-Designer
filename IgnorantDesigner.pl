#!/usr/bin/env perl

use Mojolicious::Lite;
use lib qw{lib};
use IgnorantDesigner::Model::Users;
use IgnorantDesigner::Model::Posts;
plugin 'Config';
plugin 'AntiSpamMailTo';

app->config(hypnotoad => {listen => ['http://*:8080']});

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

helper posts => sub {
    my $c = shift;
    state $posts = IgnorantDesigner::Model::Posts->new;
};


#### ROUTES

get $_ for qw(/about /contact /404);

get '/' => sub {
    my $c = shift;

    $c->stash( posts => $c->posts->brief_list );

} => 'index';

get '/blog/*post' => sub {
    my $c = shift;

    my ( $title, $date, $body ) = $c->posts->post( $c->param('post') );
    $title // $c->redirect_to('/404');

    $c->stash(
        blog_title  => $title,
        blog_date   => $date,
        blog_body   => $body,
    );

} => 'blog';

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