basexInstallationDirectory=/usr/local/
synopsxBaseDirectory=~/synopsx/
#basexInstallationDirectory=~/temp/synopsxInstallTest/
#synopsxBaseDirectory=~/temp/synopsx/
tempDir=$synopsxBaseDirectory"temp/"

baseXFileUrl=http://files.basex.org/releases/8.3/BaseX83.zip
saxonURL=http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-7J.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsaxon%2Ffiles%2F&ts=1444310806&use_mirror=skylink
synopsxBranch=dev
synopsxUrl=https://github.com/ahn-ens-lyon/synopsx/archive/$synopsxBranch".zip"
dbaUrl=https://github.com/ahn-ens-lyon/dba/archive/master.zip

mkdir -p $tempDir
cd $tempDir

echo "Installing BaseX from "$baseXFileUrl" in "$basexInstallationDirectory
wget $baseXFileUrl .
unzip BaseX83.zip
rm BaseX83.zip
mkdir -p $basexInstallationDirectory
mv basex $basexInstallationDirectory
echo "BaseX installed"

echo "Installing Saxon from "$saxonUrl" in "$basexInstallationDirectory"basex/lib"
mkdir -p $tempDir"/saxon"
cd $tempDir"/saxon"
wget $saxonUrl .
unzip SaxonHE9-6-0-7J.zip
rm SaxonHE9-6-0-7J.zip
mv *.jar $basexInstallationDirectory"lib"
echo "Saxon installed"


echo "Installing SynopsX from"$synopsxUrl" in "$synopsxBaseDirectory"synopsx"
wget "$synopsxUrl" .
unzip $synopsxBranch".zip"
rm $synopsxBranch".zip"
mkdir -p $synopsxBaseDirectory
mv synopsx-$synopsxBranch $synopsxBaseDirectory"synopsx"
ln -s $synopsxBaseDirectory"synopsx" $basexInstallationDirectory"basex/webapp"
rm $basexInstallationDirectory"basex/webapp/restxq.xqm"

echo "Installing dba from"$dba" in "$synopsxBaseDirectory"/dba"
wget "$dbaUrl" .
unzip master.zip
rm master.zip
mv dba-master $synopsxBaseDirectory"dba"
rm -fr $basexInstallationDirectory"basex/webapp/dba"
ln -s $synopsxBaseDirectory"dba" $basexInstallationDirectory"basex/webapp"

rm -fr $tempDir
echo "You can run BaseX and SynopsX with: "$basexInstallationDirectory"basex/bin/basexhttp"
