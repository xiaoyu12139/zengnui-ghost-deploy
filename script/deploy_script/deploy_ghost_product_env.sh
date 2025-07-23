#!/bin/bash

# 基础环境配置
proxy_dir=$SCRIPT_DIR/proxy.sh
config_dir=$SCRIPT_DIR/config.json

# 运行install目录下的安装脚本
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo -e "\n执行 product_env.sh脚本"
sudo bash "$SCRIPT_DIR/install_env_product.sh"

# 配置数据库
mysql_username=$(jq -r '.mysql_user // empty' $config_dir)
echo "config.json中配置的 mysql 用户名: $mysql_username"
mysql_password=$(jq -r '.mysql_password // empty' $config_dir)
echo "config.json中配置的 mysql 用户名: $mysql_password"
mysql_database=$(jq -r '.mysql_database // empty' $config_dir)
echo "config.json中配置的 mysql 用户名: $mysql_database"
echo "开始配置mysql"
sudo systemctl enable --now mysql
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS $mysql_database;
CREATE USER IF NOT EXISTS '$mysql_username'@'localhost' IDENTIFIED BY '$mysql_password';
GRANT ALL PRIVILEGES ON $mysql_database.* TO '$mysql_username'@'localhost';
FLUSH PRIVILEGES;
EOF
echo "mysql 配置完成"

echo -e "\n执行 npm.sh脚本"
sudo bash "$SCRIPT_DIR/install_npm.sh"
echo -e "\n执行 yarn.sh脚本"
sudo bash "$SCRIPT_DIR/install_yarn.sh"
echo -e "\n执行 ghost-cli.sh脚本"
sudo bash "$SCRIPT_DIR/install_ghost-cli.sh"

echo "Ghost 生产环境部署完成。"
echo "执行 ghost start 启动 Ghost 生产环境。"
echo "请确保已安装 Node.js 和 ghost-cli。"
echo "如果未安装，请先运行相关安装脚本。"