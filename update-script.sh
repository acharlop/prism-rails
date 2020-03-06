#!/bin/bash

#############
# VARIABLES #
#############
update_message="Update library to match latest Prism.js version"
javascript="js"
stylesheet="css"
stage=${javascript}
default=false
fully_automated=${1:-$default}

# repos and base path variables
prism="prism"
prism_themes="prism-themes"
external="external_libraries"

# base from paths
path_prism="./${external}/${prism}"
path_prism_themes="./${external}/${prism_themes}"
# from paths
path_from_languages="${path_prism}/components"
path_from_plugins="${path_prism}/plugins"
path_from_themes="${path_prism}/themes"
path_from_themes_additional="${path_prism_themes}/themes"

# base to paths
path_to_css="./vendor/assets/stylesheets/"
path_to_js="./vendor/assets/javascripts/"
# to paths
path_to_languages="${path_to_js}/languages"
path_to_plugins_js="${path_to_js}/prism-plugin"
path_to_plugins_css="${path_to_css}/prism-plugin"
path_to_themes="${path_to_css}/prism-theme"

# files
import_file="${path_to_js}/prism.js"
version_file="./lib/prism-rails/version.rb"
readme_file="./README.md"
changelog_file="./CHANGELOG.md"

####################
# HELPER FUNCTIONS #
####################
pushd () { command pushd "$@" > /dev/null; }

popd () { command popd "$@" > /dev/null; }

check_out_repo() {
  # get repo
  repo=$1
  # checkout repo if necessary
  [[ ! -d "$repo" ]] && git clone "https://github.com/PrismJS/${repo}.git"
  # pull latest master and tags
  pushd ${repo}
  git checkout master --quiet
  git pull --quiet
  git fetch --tags --quiet
  latest_tag=$(git describe --tags)

  echo "Checking out"
  echo "    repo: ${repo}"
  echo "    tag:  ${latest_tag}"
  echo ""
  git checkout ${latest_tag} --quiet
  popd
}

copy_files() {
  from=$1
  to=$2
  exact=${3:-$default}


  # build find command
  cmd="find ${from} -name "
  if [[ "$stage" == "$javascript" ]]; then
    cmd+='"prism-*.js" \! -name "*.min.js"'
  else
    cmd+='"prism-*.css"'
  fi

  if ${exact} ; then
    count="1"
  else
    count=`eval ${cmd} | wc -l`
  fi

  printf "Copying %10s files %10s %-40s %10s %-30s\n" "${count}" "from" "${from}" "to" "${to}"

  if ${exact} ; then
    cp ${from} ${to}
  else
    copy_cmd="${cmd} -exec cp {} ${to} \;"
    eval ${copy_cmd};
  fi
}

# Needed steps
# 6) update changelog
# 7) run rake release

#########################
# CHECK FOR GIT CHANGES #
#########################
if ! git diff-index --quiet HEAD --; then
 echo "Exiting due to uncommitted git changes"
 exit 1
fi


###################
# GET LATEST TAGS #
###################
mkdir -p ${external}
pushd ${external}
check_out_repo ${prism}
check_out_repo ${prism_themes}
popd


#########################
# COPY JAVASCRIPT FILES #
#########################
stage=${javascript}
# LANGUAGE FILES
copy_files ${path_from_languages} ${path_to_languages}
# PLUGIN FILES
copy_files ${path_from_plugins} ${path_to_plugins_js}


#########################
# COPY STYLESHEET FILES #
#########################
stage=${stylesheet}
# MAIN CSS FILE
copy_files "${path_from_themes}/prism.css" "${path_to_css}/prism.css" true
# PLUGINS FILES
copy_files ${path_from_plugins} ${path_to_plugins_css}
# THEMES FILES
copy_files ${path_from_themes} ${path_to_themes}
# EXTRA THEMES FILES
copy_files ${path_from_themes_additional} ${path_to_themes}


##########################
# JAVASCRIPT IMPORT FILE #
##########################
# find all languages
find_cmd='find . -name "prism-*.js" \! -name "*.min.js"'
# package info
header=`head -4 ${import_file} | sed 's/:/  :/g'`
# call prism highlight
footer=`tail -6 ${import_file}`

# get all languages
pushd ${path_from_languages}
languages=`eval ${find_cmd} | sort | sed 's/\.\/prism-/\/\/\= require \.\/languages\/prism-/g' | sed 's/\.js//g'`
count=`eval ${find_cmd} | wc -l | sed 's/^ *//g'`
popd

# write file
printf "%s" "${header}" > "${import_file}"
echo -e "\n//! languages : ${count}\n" >> "${import_file}"
printf "%s" "${languages}" >> "${import_file}"
echo "" >> "${import_file}"
printf "%s" "${footer}" >> "${import_file}"
echo "" >> "${import_file}"


######################
# UPDATE LIB VERSION #
######################
# get new version number
pushd ${external}/${prism}
new_version=$(git describe --tags | sed -E 's/(v|-.*$)//g')
popd

# write new version number
match_space=" [^ ]*$"
sed -i '' "2s/${match_space}/ ${new_version}/" ${import_file}
sed -i '' "2s/${match_space}/ \"${new_version}\"/" ${version_file}
sed -i '' "1s/${match_space}/ ${new_version}/" ${readme_file}

# write changelog
sed -i '' "3i\\
\\
## ${new_version} ($(date +"%Y-%m-%d"))\\
* ${update_message}\\
" ${changelog_file}


##################
# COMMIT CHANGES #
##################
if ${fully_automated} ; then
  git add .
  git commit -m "${update_message}"
  rake release
else
  echo -e "\n\n"
  echo "To finish release:"
  echo "1) Commit changes"
  echo "2) Use \"rake release\" to publish"
fi
