#!/bin/bash

# 从README中的plugin表格解析出需要添加的插件的url

# 从READMEi_english读取要添加的plugin. english版本好处理一些 
TARGET_FILE='README_english.md'

# 提取plugin表格
function extract_plugin_table(){
    in_file=$1
    out_file=$2
    while IFS= read -r line; do
        # 如果遇到标题 "### Plugins"，标记为开始提取
        if [[ "$line" == "### Plugins" ]]; then
            in_table=1
            continue
        fi
  
        # 如果已在表格部分并遇到空行，则增加换行计数器
        if [[ $in_table -eq 1 ]]; then
            if [[ -z "$line" ]]; then
                newline_count=$((newline_count + 1))
                if [[ $newline_count -ge 2 ]]; then
                    # 遇到第二个空行，停止提取
                    in_table=0
                    break
                fi
            else
                echo "$line" >> "$out_file"
            fi
        fi
    done < $in_file

    # 处理提取的内容，去掉首尾的空行
    sed -i '/^\s*$/d' "$out_file"
}

# 将md table的一行转换成数组
function parse_array(){
    local line="$1"
    line=${line:1:${#line}-2}
    IFS='|' read -r -a columns <<< "$line"
    echo ${columns[@]}
}

# 获取第i个参数
function get_index(){
    local line="$1"
    line=${line:1:${#line}-2}
    IFS='|' read -r -a columns <<< "$line"
    echo ${columns[$2]}
}

# 遍历array,找出指定的value的位置
function index_array(){
    local target=$1
    shift
    local arrays=("$@")
    if [ ${#arrays[@]} -eq 0 ];then
        echo "please input array!"
        return 2
    fi

    for i in "${!arrays[@]}";do
        if [ "${arrays[$i]}" == "$target" ]; then
            echo $i
            return 0
        fi
    done

    echo "not found."
    return 1
}

tmp_file=$(mktemp)
trap "rm $out_file" EXIT

extract_plugin_table $TARGET_FILE $tmp_file
head_a=$(parse_array "$(head -n1 $tmp_file)")
url_index=$(index_array url $head_a)

result_file=$(mktemp)
skip_line=2
while IFS= read -r line; do
    if [ ! "$skip_line" -eq 0 ];then
        skip_line=$((skip_line-1))
        continue
    fi
    raw_url=$(get_index "$line" $url_index) 
    echo ${raw_url#https://} >> $result_file
done < $tmp_file

echo $result_file


rm $tmp_file