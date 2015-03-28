#!/usr/bin/env perl

use Mojolicious::Lite;
use lib qw{lib};
use IgnorantDesigner::Model::Posts;
plugin 'AntiSpamMailTo';

app->mode('production');

plugin 'AssetPack';

app->asset('app.js' => qw{ /JS/jquery-2.1.3.js  /JS/main.js});
app->asset('app.css' => '/main.scss' );

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
        title       => $title,
        blog_date   => $date,
        metas       => $metas,
        blog_body   => $body,
    );

} => 'blog';

app->start;