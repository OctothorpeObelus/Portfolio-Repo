@ECHO off
cls
echo Authoring Tool for GreyTheRaptor's Audio Cassette Tapes, made by Octo#8888
:restart
python ./label_maker.py
pause
goto restart