#basexInstallationDirectory=/usr/local/
#synopsxBaseDirectory=~/synopsx/
basexInstallationDirectory=~/temp/synopsxInstallTest/
synopsxBaseDirectory=~/temp/synopsx/
tempDir=$synopsxBaseDirectory"temp/"

baseXFileUrl=http://files.basex.org/releases/8.3/BaseX83.zip
synopsxBranch=dev
synopsxUrl=https://github.com/ahn-ens-lyon/synopsx/archive/$synopsxBranch".zip"
dbaUrl=https://github.com/ahn-ens-lyon/dba/archive/master.zip

echo "Installing BaseX from "$baseXFileUrl" in "$basexInstallationDirectory
mkdir -p $tempDir
cd $tempDir
wget $baseXFileUrl .
unzip BaseX83.zip
rm BaseX83.zip
mkdir -p $basexInstallationDirectory
mv basex $basexInstallationDirectory
echo "BaseX installed"

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
