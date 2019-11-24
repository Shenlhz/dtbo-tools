#!/bin/sh
# BY Shenlhz

./bin/mkdtimg dump dtbo.img -b dtb
for i in `find dtb.*`; do
./bin/dtc -I dtb -O dts -@ $i -o $i.dts
mv $i.dts dts.$i
done
rm -rf dtb.*
rm -rf dts
mkdir dts
mv dts.dtb.* dts
info=`cat Info.txt`
hz=`printf %x $info`
Patch1=`grep -l -r -n "qcom,mdss-dsi-panel-framerate = <0x3c>" ./dts`
sed -i "s/qcom,mdss-dsi-panel-framerate = <0x3c>/qcom,mdss-dsi-panel-framerate = <0x$hz>/g" $Patch1
var=`expr "scale=5;$info / 60"|bc`
var2=`expr "$var * 1100000000"|bc`
var3=`printf %x $var2`
Patch2=`grep -l -r -n "qcom,mdss-dsi-panel-clockrate = <0x4190ab00>" ./dts`
sed -i "s/qcom,mdss-dsi-panel-clockrate = <0x4190ab00>/qcom,mdss-dsi-panel-clockrate = <0x$var3>/g" $Patch2
mv ./dts/dts.dtb.* ./
rm -rf dts
for i in `find dts.dtb.*`; do
./bin/dtc -I dts -O dtb -@ -o $i.dtb $i
mv $i.dtb dtb.$i
done
rm -rf dts.dtb.*
./bin/mkdtimg create dtbo_new.img dtb.dts.dtb.*
rm -rf dtb.dts.dtb.*
