@echo off
echo Automatic Backup Oracle
echo -----------------------
echo -----------------------
RMAN target shop_of_hobbies_supeadmin/Password@shop_of_hobbies @A:\3k2s\DB_CourseWork\runRestore.rman;
PAUSE;
