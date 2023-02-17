#!/bin/bash
#$1 : KEY PATH/FILE
# shellcheck disable=SC2086
# shellcheck disable=SC2181
#set -e


################# VARS ########################
DIR_PATH=${1%/*}
FILE=${1##*/}
KEY_NAME=${FILE%_*}


################# FUNCTIONS ########################
function importKeypair(){
  mv $1 $1.pem &&
  echo "importing generated ssh key to ec2 key pair..." &&
  aws ec2 import-key-pair --key-name $2 --public-key-material fileb://$1.pub --no-cli-pager
}

function reimportKeypair(){
  echo "reimportKeypair $2"
  aws ec2 delete-key-pair --key-name $2 &&
  echo "deleted imported ec2 key pair !" &&
  aws ec2 import-key-pair --key-name $2 --public-key-material fileb://$1.pub --no-cli-pager;
}

################# LOGIC ########################
if [ -d $DIR_PATH ]
then
  echo "existed directory."

  if [ -z "$(find $DIR_PATH -maxdepth 1 -name \*"$FILE"\*)" ]
  then
      echo "not existed file !"
      ssh-keygen -q -t rsa -b 2048 -m pem -C $KEY_NAME -f $1 -N ""


        if [ $? -eq 0 ]
        then
          echo "generated ssh key !"
          importKeypair $1 $KEY_NAME

          if [ $? -eq 0 ]
          then
              echo "imported generated ssh key to ec2 key pair !"
          else
            reimportKeypair $1 $KEY_NAME

            if [ $? -eq 0 ]
            then
              echo "imported generated ssh key to ec2 key pair !"
            fi

          fi

        fi

  else
    echo "existed file !"
      rm $1*

      if [ $? -eq 0 ]
      then
        ssh-keygen -q -t rsa -b 2048 -m pem -C $KEY_NAME -f $1 -N ""

        if [ $? -eq 0 ]
        then
          echo "generated ssh key"
          importKeypair $1 $KEY_NAME

          if [ $? -eq 0 ]
          then
              echo "imported generated ssh key to ec2 key pair !"
          else
            reimportKeypair $1 $KEY_NAME

              if [ $? -eq 0 ]
              then
                echo "imported generated ssh key to ec2 key pair !"
              fi
          fi

        fi

      fi

  fi
##################### NOT EXISTED DIR #############################
else
  echo "not existed directory !"
  mkdir $DIR_PATH &&
  ssh-keygen -q -t rsa -b 2048 -m pem -C $KEY_NAME -f $1 -N "" &&
  echo "generated ssh key" &&
  importKeypair $1 $KEY_NAME

  if [ $? -eq 0 ]
  then
    echo "imported generated ssh key to ec2 key pair !"
  else
    reimportKeypair $1 $KEY_NAME

    if [ $? -eq 0 ]
    then
      echo "imported generated ssh key to ec2 key pair !"
    fi
  fi
fi

