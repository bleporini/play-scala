PID_FILE=/tmp/RUNNING_PID

rm -f $PID_FILE

./$APP_NAME -Dpidfile.path=$PID_FILE 
