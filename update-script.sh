#!/bin/bash

#############
# VARIABLES #
#############
javascript="js"
stylesheet="css"
stage=${javascript}

prism="prism"
prism_themes="prism-themes"
external="external_libraries"

path_prism="./${external}/${prism}"
path_prism_themes="./${external}/${prism_themes}"
path_from_languages="${path_prism}/components"
path_from_plugins="${path_prism}/plugins"
path_from_themes="${path_prism}/themes"
path_from_themes_additional="${path_prism_themes}/themes"

path_to_css="./vendor/assets/stylesheets/"
path_to_js="./vendor/assets/javascripts/"
path_to_languages="${path_to_js}/prism"
path_to_plugins_js="${path_to_js}/prism-plugins"
path_to_plugins_css="${path_to_css}/prism-plugins"
path_to_themes="${path_to_css}/prism-themes"


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
  echo "    tag: ${latest_tag}"
  echo ""
  git checkout ${latest_tag} --quiet
  popd
}

copy_files() {
  from=$1
  to=$2

  default=false
  exact=${3:-$default}


  # build find command
  cmd="find ${from} -name "
  if [[ "$stage" == "$javascript" ]]; then
    cmd+='"*.js" \! -name "*.min.js"'
  else
    cmd+='"*.css"'
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
# 1) copy prism.js to vendor/javascript/prism.js
# 2) check there are 121 languages if not add to prism-rails.js
# 3) copy files over -- cp `find . -name "*.js" \! -name "*.min.js"` ../../prism-rails/vendor/assets/javascripts/prism/
# 4) List what's been changed
# 5) copy plugins to prism-plugin/ folder js and css
# 6) update changelog
# 7) run rake release

#########################
# CHECK FOR GIT CHANGES #
#########################
#if ! git diff-index --quiet HEAD --; then
 echo "Exiting due to uncommitted git changes"
 exit 1
#fi


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
# MAIN JS FILE
# LANGUAGE FILES
copy_files ${path_from_languages} ${path_to_languages}
# PLUGIN FILES
copy_files ${path_from_plugins} ${path_to_plugins_js}


#########################
# COPY STYLESHEET FILES #
#########################
stage=${stylesheet}
# MAIN CSS FILE
copy_files "${path_prism}/style.css" "${path_to_css}/prism.css" true
# PLUGINS FILES
copy_files ${path_from_plugins} ${path_to_plugins_css}
# THEMES FILES
copy_files ${path_from_themes} ${path_to_themes}
# EXTRA THEMES FILES
copy_files ${path_from_themes_additional} ${path_to_themes}

exit 0

# copy non minified javascript language file to gem folder
echo "Copying Files"
lang_count=0
for f in `find ./prism/components -name "*.js" \! -name "*.min.js"`
do
  ((lang_count++))
  echo $f
  cp -f $f $gem_lang_js
done
echo -e "    language files copied: ${lang_count}"

echo "TEMP EXIT"
exit 0


# copy non minified javascript language file to gem folder
plug_count=0
for f in `find ./prism/plugins/ -name "*.js" \! -name "*.min.js"`
do
  ((plug_count++))
  cp -f $f "${gem_js}/prism-plugin"
done
echo -e "\n${plug_count} - plugin files copied"

# commit
# TODO check files and commit with standard
# git commit -a -m "Update javascript files to version ${version number}"


# javascript copy reporting
js_count=`ls -1 ${gem_js} | wc -l | xargs`
cp_js_count=$((plug_count + lang_count))
echo "---------------------------"
echo -e "${cp_js_count} out of ${js_count} javascript files updated\n"


# copy non minified styles to gem folder
base_count=0
for f in `find ./prism/themes/ -name "*.css"`
do
  ((base_count++))
  cp -f $f $gem_cs
done
echo -e "\n${base_count} - base themes files copied"


# copy non minified styles to gem folder
plug_count=0
for f in `find ./prism/plugins/ -name "*.css"`
do
  ((plug_count++))
  cp -f $f $gem_cs
done
echo -e "\n${plug_count} - plugin theme files copied"


# copy non minified styles to gem folder
styl_count=0
for f in `find ./prism-themes/themes/ -name "*.css"`
do
  ((styl_count++))
  cp -f $f $gem_cs
done
echo -e "\n${styl_count} - extra themes files copied"


# css copy report
cs_count=`ls -1 ${gem_cs} | wc -l | xargs`
cp_cs_count=$((base_count + styl_count + plug_count))
echo "---------------------------"
echo -e "${cp_cs_count} out of ${cs_count} css files updated\n\n"


# git diff report
cd $gem
git diff --stat
echo -e "\n\n"

# update versioning
old_version=`head -1 ./temp_prism/prism-rails/README.md | grep -o "[0-9]\.[0-9]\.[0-9]"`
new_version=`grep "version" ./temp_prism/prism/package.json | grep -o "[0-9]\.[0-9]\.[0-9]"`

for f in "./prism-rails/README.md" "./prism-rails/lib/prism-rails/version.rb"
do
  sed -i "" "s/${old_version}/${new_version}/g" $f
  echo -e "${f} version updated from ${old_version} to ${new_version}\n"
done

# non automated tasks
echo -e "\n\n"
echo "To finish release:"
echo "1) Commit changes"
echo "2) Use \"rake release\" to publish"


