#!/bin/bash

# このスクリプトはstagingタグを作成します
# デフォルトではorigin/devブランチをタグのつけ先としますが、引数でタグのつけ先を指定することも可能です
# 例: ./script/create-staging-tag.sh origin/feature/1234

set -Ceu

git fetch origin --tags
git fetch origin dev

prefix="staging"
current_date=$(date +"%Y%m%d")

# 既存のタグで同じ日付のものを検索し、最大の連番を取得
last_tag=$(git tag | grep "^${prefix}\.${current_date}" | sort -V | tail -n 1)

if [[ -z "$last_tag" ]]; then
    # タグが存在しない場合は、01
    incremented_number="01"
else
    # 既存のタグが存在する場合は連番をインクリメント
    number=$(echo $last_tag | awk -F'.' '{print $3}')
    incremented_number=$(printf "%02d" $((10#$number + 1)))
fi
new_tag="${prefix}.${current_date}.${incremented_number}"

# タグのつけ先を引数で受け取る。引数がなかった場合は、origin/dev
target_branch=${1:-origin/dev}
git tag $new_tag $target_branch
echo "Created new tag: $new_tag on branch: $target_branch"
