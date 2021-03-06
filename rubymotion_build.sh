#!/bin/sh

PATH=$1
CMD=$2
ENV=$3

if [ "$CMD" = "" ]; then
	CMD="rake build"
fi
if [ "$ENV" != "" ]; then
	eval . $ENV
fi
if type bundle >/dev/null 2>&1; then
    CMD="bundle exec ${CMD}"
fi

$CMD 2>&1 | ruby -e "\
	build_dir = Dir.pwd;\
	until FileTest.exist?(build_dir + '/Rakefile');\
		build_dir = File.dirname(build_dir);\
		break if build_dir == '/';\
	end;\
	ARGF.each do |line|;\
		STDERR.puts line.gsub(/^\.\//, build_dir + '/').gsub(/\\x1b.../, '');\
	end"
