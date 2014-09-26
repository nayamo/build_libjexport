user=$1
pass=$2
tag=$3
outputdir_name=$4 #手動実行専用、通常タグの数値に合わせて作成する出力先ディレクトリ名を任意の名称で作成する
devtrac=hoge.hoge.co.jp

cd /root/build_libjexport
set +e
rm -rf temp
set -e
mkdir temp
cd temp
svn export --no-auth-cache --username $user --password $pass svn://$devtrac/coreengine/tags/$tag
svn export --no-auth-cache --username $user --password $pass svn://$devtrac/coreengine/branches/branch_dspline 
svn export --no-auth-cache --username $user --password $pass svn://$devtrac/timetable/trunk ./timetable

mv timetable branch_dspline/lib/timetable

cp -af ../CMakeLists.txt branch_dspline/lib

rm -f branch_dspline/lib/DispLineLib/ltt_compat.*

rsync --delete --exclude=".svn" -avz $tag/lib/ExpAddr   branch_dspline/lib
rsync --delete --exclude=".svn" -avz $tag/lib/ExpDiaLib branch_dspline/lib
rsync --delete --exclude=".svn" -avz $tag/lib/ExpLib    branch_dspline/lib
rsync --delete --exclude=".svn" -avz $tag/lib/ExpToku   branch_dspline/lib
rsync --delete --exclude=".svn" -avz $tag/lib/Platform  branch_dspline/lib
rsync --delete --exclude=".svn" -avz $tag/lib/RosenMap  branch_dspline/lib

cd branch_dspline/lib
rm -fr build
mkdir build
cd build/
cmake ..
make

chmod 777 *

yyyymmdd=`echo $tag|sed -e "s/[^0-9]//g"`
if [ -n "$outputdir_name" ];then
    yyyymmdd=$outputdir_name
fi
set +e
mkdir                      /home/samba/eee_doc/branch_dspline/lib/$yyyymmdd
set -e
cp -af libjexport.so.1.0.0 /home/samba/eee_doc/branch_dspline/lib/$yyyymmdd/libjexport.so

