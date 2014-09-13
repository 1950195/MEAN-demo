# MEAN Demo

**MongoDB(Mongoose) + ExpressJS + AngularJS + NodeJS 建站实例**
**js采用coffee-script语法**
**css采用compass-style**

## 涉及到的技术和框架 ##

* [coffee-script](http://coffee-script.org/)
* [bootstrap.sass](http://v3.bootcss.com/)
* [compass](http://compass-style.org/)
* [angularjs](http://angularjs.org/), [墙内镜像](http://www.ngnice.com/)
* [expressjs](http://expressjs.com/)
* [handlebarsjs](http://handlebarsjs.com/)
* [nodejs](http://www.nodejs.org/)
* [mongodb](http://www.mongodb.org/)
* [mongoosejs](http://mongoosejs.com/)

## 开发环境(win7) ##

* [下载git GUI Clients](http://git-scm.com/downloads)
* [下载ruby](http://rubyinstaller.org/downloads/)
* rubyGem(会等待很久才有反应，不要着急关闭命令窗口)

```bash
>gem update --system
>gem install rubygems-update
>update_rubygems
>gem sources -a http://gems.github.com
>gem sources -a http://gems.rubyforge.org
```

* compass

```bash
>gem install compass
```

* [下载nodejs](http://nodejs.org/download/)
* [下载npm](https://github.com/npm/npm/tags)，下载解压之后用管理员权限打开命令提示行，切换至目录执行：

```bash
>node cli.js install -gf
```

* [下载mongodb](http://www.mongodb.org/downloads)
* 运行mongodb
    * 新建文件夹E:\mongodb\logs和E:\mongodb\logs
    * 新建文件E:\mongodb\logs\mongodb.log
    * 执行以下命令再到服务中启动mongodb

```bash
>mongod --dbpath E:\mongodb\data --logpath=E:\mongodb\logs\mongodb.log --serviceName MongoDB --install
```

## 开发环境(Mac) ##

* git, node，gongodb

```bash
$ brew install git
$ brew install node
$ brew install mongodb
$ mkdir -p ~/mongodb/data
$ mkdir -p ~/mongodb/logs
$ touch ~/mongodb/logs/mongodb.log
$ mongod --dbpath ~/mongodb/data --logpath=~/mongodb/logs/mongodb.log --install
```

* rubyGem, compass, 其中ruby版本请先查清楚版本号，下面的例子是v2.1.2

```bash
$ curl -L https://get.rvm.io | bash -s stable
$ rvm pkg install openssl
$ rvm install 2.1.2
$ rvm use 2.1.2
$ gem install rails
$ gem install compass
```

## 开发环境(Ubuntu 14.04)

* Git系统自带
* rubyGem

```bash
$ sudo apt-get update
$ sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
$ sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
$ curl -L https://get.rvm.io | bash -s stable
$ source ~/.rvm/scripts/rvm
$ echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
$ rvm install 2.1.2
$ rvm use 2.1.2 --default
$ ruby -v
$ echo "gem: --no-ri --no-rdoc" > ~/.gemrc
```

* compass

```bash
$ gem install compass
```

* nodeJS

```bash
$ sudo add-apt-repository ppa:chris-lea/node.js
$ sudo apt-get update
$ sudo apt-get install -y nodejs
```

* mongodb install

```bash
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
$ echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
$ sudo apt-get update
$ sudo apt-get install -y mongodb-org
```

* mongodb start

```bash
$ sudo service mongod start
```

* mongodb log show

```bash
$ sudo tail /var/log/mongodb/mongod.log
```

## 开发环境(CentOS) ##

* [git官网](http://git-scm.com/)
* [nodejs官网](http://nodejs.org/)
* [mongodb官网安装说明](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/)
* rubyGem, compass, 其中ruby版本请先查清楚版本号，下面的例子是v2.1.2

```bash
$ yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel sqlite-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel
$ curl -L https://get.rvm.io | bash -s stable
$ rvm pkg install openssl
$ rvm install 2.1.2
$ rvm use 2.1.2
$ gem install rails
$ gem install compass
```

## 服务器指令 ##

* 部署node module

```bash
$ npm install
```

* 运行项目（由于我配置的80端口，所以需要sudo）

```bash
$ compass compile --config .compass/config.rb --force
$ npm install
$ node_modules/.bin/coffee build/init.coffee
$ node_modules/.bin/coffee --compile ./assets/js/
$ sudo npm start
```

* 监听.scss .coffee，自动编译

```bash
$ compass watch --config .compass/config.rb --force
$ node_modules/.bin/coffee --watch --compile ./assets/js/
```

* compass编译scss Production Environment

```bash
$ compass compile --config .compass/config.rb -e production --force
```
