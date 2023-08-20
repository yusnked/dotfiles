#output a run.sh that real cut and concat the file
#use ffmpeg,thanks for its developer
if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ]
then
	echo "please input paramenter:\$1[time_pairs_txt],\$2[media_file],\$3[media_file]"
	exit 2
fi

time_pairs_txt=$1
input=$2
input=`printf %q "$input"`
output='date "+%Y_%m_%d_%H_%M_%S"'
dir_name=.cut_video
dir_path=$3
sh_dir=$4
IFS=$'/' f=($2)
file_name=${f[${#f[*]}-1]}
echo "file name:$file_name"
IFS=$'.' t=($file_name)
file_format=${t[${#t[*]}-1]}
echo "dirpath:$dir_path"
eval cd "$sh_dir"
echo "path:$dir_path"
echo "f:`pwd`"
echo "cd \"$dir_path\"" > run.sh
echo "mkdir $dir_name" >> run.sh

IFS=$'\n' a=(`eval cat $time_pairs_txt`)
num=${#a[@]}
for  i  in  ${!a[@]};do
	IFS=',' seg=(${a[i]})
	left=${seg[0]}
	right=${seg[1]}
	duration=$(echo "scale=2;$right-$left" |bc)
	echo "ffmpeg -ss $left -i $input -t $duration  $dir_name/clip$i.$file_format" >>run.sh

	echo "echo \"file 'clip$i.$file_format'\" >>$dir_name/concat.txt" >>run.sh
done

if [ $num == 1 ]
then
   echo "cp mode"
   echo "cp $dir_name/clip0.$file_format \"\`$output\`_cut_$file_name\"" >>run.sh
else
   echo "concat mode"
   echo "ffmpeg -f concat -i $dir_name/concat.txt -c copy \"\`$output\`_cut_$file_name\"" >>run.sh
fi

echo "rm -rf $dir_name" >>run.sh
echo "echo OK!" >>run.sh
echo "echo srcipt_dir:`pwd`" >>run.sh
chmod +x run.sh
echo "run.sh has generated"

