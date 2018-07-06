#!/usr/bin/env bash

readonly RED="\\033[1;31m"
readonly GREEN="\\033[1;32m"
readonly BLUE="\\033[1;34m"
readonly END="\\033[1;00m"

_E="-e"

readonly BASEDIR=$( cd $( dirname $0 ) && pwd )
readonly GITREPO=$BASEDIR/gr
readonly BUILDDIR=$GITREPO/extra/ui/build
readonly MDDIR=$BASEDIR/md
readonly DOCKER_IMAGE='bwnyasse/dart:2.0.0-dev.54.0'
readonly MD_2_CODELAB_PARSER='https://github.com/bwnyasse/md2codelab.git'

usage() {
	cat <<-EOF

	Usage: Use to compile the project


	OPTIONS:
	========
		--launch Launch a docker container for the build
		--compil Effective project compilation
		--cleanup Clean up the directory
		-h   Display this message

	EOF
}

_print_title() {
	echo ""
	echo $_E "$BLUE# $* $END"
	echo ""
}


_print_error_and_exit() {
	echo $_E "${RED}ERREUR: $1 $END\n" >&2 && exit ${2:-2}
}

_print_info() {
	echo $_E "${GREEN}INFO: $* $END"
}


_build_ui() {
    _print_title "Build Diff Tech Codelabs UI Angular"

    if [[ -f $GITREPO ]];then
        cd $GITREPO && git pull
    else
 	    git clone $MD_2_CODELAB_PARSER $GITREPO || _print_error_and_exit "Impossible de clone le repo $MD_2_CODELAB_PARSER"
    fi

 	cd $GITREPO/extra/ui || _print_error_and_exit "Impossible de se positionner dans le répertoire UI"

    pub global activate -sgit $MD_2_CODELAB_PARSER \
        && pub global activate webdev \
        && pub get \
        && export PATH="$PATH":"~/.pub-cache/bin" \
        && webdev build --output web:$BUILDDIR --release \
        && mkdir -p $BUILDDIR/md \
        && rm -rf $BUILDDIR/packages || _print_error_and_exit "Error while building UI"

}

_build_md() {
	pub global activate -sgit $MD_2_CODELAB_PARSER
	cd $MDDIR

	_print_title "Converting *.md to google codelabs html format"

	count=$(find . -iname '*.md' | wc -l)
	[[ $count == 0 ]] && _print_error_and_exit "No .md file to convert"

	pub global run md2codelab:main --input $MDDIR/ --withjson true || _print_error_and_exit "Error while building codelab html"

	[[ -f config.yaml ]] && mv config.yaml $BUILDDIR/
	[[ -f md.json ]] && mv md.json $BUILDDIR/
	[[ -f md_search.json ]] && mv md_search.json $BUILDDIR/

	mv * $BUILDDIR/md/

	return 0
}

_synchronize() {
	_print_title "Synchronise to build/"

    mkdir -p /app/build

    cp -R $BUILDDIR/ /app/build || print_error_and_exit "Error while synchronising $BUILDDIR"

    #TODO : must provide better way to fetch dependencies
    cp -R /app/gr/.dependencies/* /app/build/md/ || print_error_and_exit "Error while synchronising dependencies"
}


_build_in_docker() {
	_build_ui

	_build_md

    _synchronize

	_print_info "Work done !"
}

_launch() {

		docker run \
			--rm \
			-v $PWD:/app \
			$DOCKER_IMAGE bash -c 'cd /app && /bin/bash build.sh --compil'
}

_cleanup() {
	sudo rm -rf $GITREPO/
}

#                  _
#  _ __ ___   __ _(_)_ __
# | '_ ` _ \ / _` | | '_ \
# | | | | | | (_| | | | | |
# |_| |_| |_|\__,_|_|_| |_|
#

while getopts :-:h option
do
	case $option in
		-)
			case $OPTARG in
				launch)
					_launch
					;;
				compil)
					_build_in_docker
					;;
				cleanup)
					_cleanup
					;;
				*)
					print_error "unknown parameter '--$OPTARG'"
					usage
					exit 2
					;;
				esac
			;;
		:|?|h)
			[[ $option == \? ]] && print_error "Option-$OPTARG is unknown !"
			[[ $option == : ]] && print_error "Option -$OPTARG need a value !"
			usage
			exit $([[ $option == h ]] && echo 0 || echo 2)
			;;
	esac
done
