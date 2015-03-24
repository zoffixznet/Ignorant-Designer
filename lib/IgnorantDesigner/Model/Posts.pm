
package IgnorantDesigner::Model::Posts;

use Moo;
use Text::Markdown 'markdown';
use File::Glob qw/bsd_glob/;
use File::Slurp::Tiny 'read_file';
use List::UtilsBy qw/sort_by/;
use Encode;

sub brief_list {
    my $self = shift;

    my @posts= bsd_glob 'blog_src/*';

    for ( @posts ) {
        s{^blog_src/}{};
        my ( $date, $title ) = /(\d{4}-\d{2}-\d{2})-(.+)\.md/;
        $title =~ tr/-/ /;
        $_ = {
            date    => $date,
            title   => $title,
            url     => s/.md$//r,
        };
    }

    @posts = reverse sort_by { $_->{date} } @posts;

    return \@posts;
}

sub post {
    my $self = shift;
    my $post = shift;
    my ( $date, $title ) = $post =~ /(\d{4}-\d{2}-\d{2})-(.+)/;
    $title =~ tr/-/ /;

    $post = 'blog_src/' . $post =~ s/[^\w-]//rg . '.md';

    return
        unless -e $post;

    my $content = decode 'utf8', read_file $post;

    return (
        $title,
        $date,
        markdown $content,
    );
}

1;

__END__