#!/bin/sh

if [ -z "$email" ]    || \
   [ -z "$authmail" ] || \
   [ -z "$password" ]; then
  2>&1 echo "You need to set \$email, \$authmail and \$password env variables!"
  exit
fi

sed --in-place "s/EMAIL/$email/"         /root/.mailrc
sed --in-place "s/AUTHMAIL/$authmail/"   /root/.mailrc
sed --in-place "s/PASSWORD/$password/"   /root/.mailrc

print_help() {
  echo "Usage: $0 [OPTION] <ARGUMENT>"
  echo
  echo "Interface to mailx with authentication for use inside a container"
  echo
  echo "Mandatory parameters:"
  echo "  --help                   Print this help and exit"
  echo "  --subject \"<SUBJECT>\"  Use this as mail subject"
  echo "  --content \"<CONTENT>\"  E-Mail content"
  echo "  --rcpt    \"<RCPT>\"     (List) of recipients"
  echo
  exit 0
}

while [ $# -gt 0 ]; do
  case $1 in
    --help) print_help;;
    --rcpt)
      [ -z "$2" ] && print_help
      rcpt="$2"
      shift
      ;;
    --subject)
      [ -z "$2" ] && print_help
      subject="$2"
      shift
      ;;
    --content)
      [ -z "$2" ] && print_help
      content="$2"
      shift
      ;;
    *) print_help;;
  esac
  shift
done 

if [ -z "$subject" ] || [ -z "$content" ] || [ -z "$rcpt" ]; then
  print_help
fi

echo "$content" | mail -s "$subject" -A gmail -r $email $rcpt
