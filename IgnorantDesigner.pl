#!/usr/bin/env perl

use Mojolicious::Lite;
use lib qw{lib};
use IgnorantDesigner::Model::Posts;
plugin 'AntiSpamMailTo';

app->config(hypnotoad => {listen => ['http://*:8080']});

require 'lib/data.html';
push @{ app->renderer->classes }, 'Fake';

#### HELPERS

helper posts => sub {
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

    my ( $title, $date, $metas, $body )
    = $c->posts->post( $c->param('post') );

    $title // $c->redirect_to('/404');

    $c->stash(
        blog_title  => $title,
        blog_date   => $date,
        metas       => $metas,
        blog_body   => $body,
    );

} => 'blog';

app->start;