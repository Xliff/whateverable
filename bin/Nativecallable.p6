#!/usr/bin/env perl6

use Whateverable;
use Whateverable::Bits;
use Whateverable::Output;
use Whateverable::Processing;

unit class Nativecallable does Whateverable;

method help($msg) {
    “Like this {$msg.server.current-nick}: <some C definition>”;
}

sub run-gptrixie($header-file) {
    my %ENV = %*ENV.clone;
    %ENV<PATH> = join ‘:’, ‘/home/bisectable/.rakudobrew/bin’, %ENV<PATH>; # TODO
    my %output = get-output :%ENV, ‘gptrixie’, '--silent', ‘--all’, ‘--castxml=c99’, $header-file;
    if %output<output>.lines > 20 {
        return ‘’ but FileStore(%(‘GPTrixiefied.pm6’ => "#Generated by App::GPTrixie\n" ~ %output<output>))
    }
    my @pruned-output;
    @pruned-output = %output<output>.lines.grep: { $_ and not .starts-with: ‘#’ };
    if @pruned-output ≤ 10 {
        return (@pruned-output.map: {.subst(/\s+/, " ", :g)}).join: “\n”;
    }
    my $definitive-output //= %output<output>;
    ‘’ but FileStore(%(‘result.pm6’ => "#Generated by App::GPTrixie\n" ~ $definitive-output))
}

multi method irc-to-me($msg where /^ \s* $<code>=.+ /) {
    my $file = process-code $<code>, $msg;
    my $code = slurp $file;
    $file.unlink;
    my $header-file = '/tmp/gptnc.h';
    spurt $header-file, “\n#include <stddef.h>\n#include <stdbool.h>\n” ~ $code;
    LEAVE unlink $_ with $header-file;
    run-gptrixie($header-file)
}


my %*BOT-ENV;

Nativecallable.new.selfrun: ‘nativecallable6’, [ / nativecall6? <before ‘:’> /,
                                                 fuzzy-nick(‘nativecallable6’, 2) ];
