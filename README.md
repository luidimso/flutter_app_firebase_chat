## Important commands

Generate SHA1 key on Windows

`keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android`

Generate SHA1 key on Linux or Mac

`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android`

These commands must be running on bin folder on Java Home directory. To find Java Home directory on Mac, run `/usr/libexec/java_home`.