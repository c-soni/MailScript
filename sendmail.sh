# A variable which will be used to change the email subject based on whether the
# build succeeds or fails.
SUCCESS=SUCCESS

# Replace with your build command (before the pipe '|').
make |& tee logs.txt

# Simple check for the word "Error" in the last 20 lines of output. This is used
# to change the email subject if the build fails.
LOGS=$(tail -n 10 logs.txt)
if [[ $LOGS = *"Error"* ]]; then
  SUCCESS=FAILURE;
fi

# Email the last 10 lines of the logs. The -s command sets the subject of the
# email while the piped text is the body. Replace the email id as needed.
echo $LOGS | mutt -s "[PROJECT_BUILD] $SUCCESS" user.name@email.com

# A neat little loop to ring the terminal bell for 2.5 minutes after the build
# is finished, especially handy if you work on multiple systems. It requires
# your terminal bell to be enabled explicitly in the terminal profile. Steps may
# vary based on the system you are on, best to look it up online.
for i in {1..150}; do
  tput bel;
  sleep 1;
done
