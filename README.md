# Installation #

Create the Android project via the (Phonegap-Tools)[https://github.com/davidbillamboz/PhoneGap-Tools].<br>
Configure it (see the Phonegap-Tools Installation description).<br>
<br>
Create the Xcode project.<br>
Edit the Run Script in the Project Build Phases. Remove everything and add the following line:<br>
<pre>
cp /Users/Shared/PhoneGap/Frameworks/PhoneGap.framework/www/phonegap-1.2.0.js "$PROJECT_DIR/www/assets/libs/"
</pre>