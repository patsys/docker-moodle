#!/bin/sh
file=$MOODLE_HTDOCS/index.php
cd $MOODLE_HTDOCS
if [ ! -f "$file" ] || [ `wc -c <"$file"` -le 100 ]; then
  durl=`lynx -dump -hiddenlinks=listonly http://download.moodle.org/releases/latest/ | grep -m 1  -o -e "http://.*org/stable.*.*tgz"`
  wget $durl
  ln -s . moodle
  tar  -xzf *moodle*.tgz moodle
  rm moodle
  /utils/exist_moodle_update.sh
  mkdir -p ../moodledata && chown apache:apache ../moodledata
  chown -R apache:apache .
  option="--non-interactive --agree-license"
  [ ! -z "$MOODLE_LANG" ] && option="$option --lang=$MOODLE_LANG"
  [ ! -z "$MOODLE_URL" ] && option="$option --wwwroot=$MOODLE_URL"
  [ -z "$MOODLE_DATA_PATH" ] && MOODLE_DATA_PATH=`readlink -m ../moodledata`
  option="$option --dataroot=$MOODLE_DATA_PATH"
  mkdir -p $MOODLE_DATA_PATH && chown apache:apache $MOODLE_DATA_PATH
  [ ! -z "$MOODLE_DB_TYPE" ] && option="$option --dbtype=$MOODLE_DB_TYPE"
  [ ! -z "$MOODLE_DB_HOST" ] && option="$option --dbhost=$MOODLE_DB_HOST"
  [ ! -z "$MOODLE_DB_NAME" ] && option="$option --dbname=$MOODLE_DB_NAME"
  [ ! -z "$MOODLE_DB_USER" ] && option="$option --dbuser=$MOODLE_DB_USER"
  [ ! -z "$MOODLE_DB_PASSWORD" ] && option="$option --dbpass=$MOODLE_DB_PASSWORD"
  [ ! -z "$MOODLE_SITE_FULLNAME" ] && option="$option --fullname=$MOODLE_SITE_FULLNAME"
  [ ! -z "$MOODLE_SITE_SHORTNAME" ] && option="$option --shortname=$MOODLE_SITE_SHORTNAME"
  [ ! -z "$MOODLE_SUMMERY" ] && option="$option --summary=$MOODLE_SUMMERY"
  [ ! -z "$MOODLE_ADMIN_USER" ] && option="$option --adminuser=$MOODLE_ADMIN_USER"
  [ ! -z "$MOODLE_ADMIN_PASSWORD" ] && option="$option --adminpass=$MOODLE_ADMIN_PASSWORD"
  [ ! -z "$MOODLE_ADMIN_EMAIL" ] && option="$option --adminemail=$MOODLE_ADMIN_EMAIL"
  cd ./admin/cli
  out=`sudo -u apache php install.php $option`
  ret=$?
  if [ "$ret" -ne 0 ];then
    echo "$out"
    echo "Moodle install fail Errocode: $ret"
    exit 3
  fi
fi
