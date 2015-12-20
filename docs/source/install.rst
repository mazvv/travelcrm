Установка
=========

Требования
##########

Для успешной установки TravelCRM необходимо установить Python версии 2.7. 
Подробнее об установке Python на свой компьютер можно ознакомиться в 
`официальной документации Python <https://docs.python.org/2/using/index.html>`_.

PostgreSQL 9.*, для более ранних версий не тестировалось.

.. note::
   Автор тестировал TravelCRM на Linux Fedora Core, Python 2.7 и
   Centos 5; PostgreSQL 9.4
   
Установка на Unix/Linux
#######################
Рекомендуемым способом установки TravelCRM является установка в виртуальном 
окружении Python, что обеспечивает локальную независимость пакетов Python от
глобального окружения. Для этих целей можно воспользоваться пакетом
*virtualenv*. 

Чтобы настроить *virtualenv* в которую будет установлен TravelCRM, 
сначала убедитесь, что установлен пакет *setuptools* ::

   $ python -c 'import setuptools'

Если результатом этой комманды будет пустая строка, то *setuptools* уже установлен,
если же будет получен результат вида::

   Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
   ImportError: No module named setuptools

то необходимо установить *setuptools* вручную

Ручная установка setuptools
###########################
Для установки *setuptools* руками, скачайте `ez_setup.py <http://peak.telecommunity.com/dist/ez_setup.py>`_ и запустите его, используя
установленный интерпретатор Python::

   $ python ez_setup.py

Эта комманда выполнит установку *setuptools* на компьютер в глобальную установку Python.
Если во время выполнения возникнет ошибка доступа, то используйте комманду::

   $ sudo python ez_setup.py

или выполните установку как пользователь root.

Установка virtualenv
####################
После установки *setuptools*, необходимо установить пакет virtualenv. Для этого
достаточно запустить комманду установки::

   $ easy_install virtualenv

Если во время установки произошли ошибки доступа, попробуйте использовать::

   $ sudo easy_install virtualenv

или повторить установку как пользователь root.

Создание виртуальной среды
##########################
После успешной установки virtualenv можно создавать виртуальное окружение Python.
Прежде всего создайте директорию, в которую хотите установить TravelCRM::

   $ mkdir ~/Projects/virtenv

создаем в этой директории виртуальное окружение Python::

   $ virtualenv ~/Projects/virtenv


Установка TravelCRM в виртуальное окружение
###########################################

Прежде всего нужно `скачать TravelCRM <https://bitbucket.org/mazvv/travelcrm/downloads>`_ 
и распаковать в директорию с виртуальным окружением::

   $ cd ~/Projects/virtenv
   $ wget https://bitbucket.org/mazvv/travelcrm/downloads/travelcrm-0.6.4.dev0.tar.gz
   $ tar -xzvf travelcrm-0.6.4.dev0.tar.gz
   $ cd ./travelcrm-0.6.4.dev0

Запустите установку TravelCRM::

   $ ../bin/python ./setup.py develop

Комманда установки автоматически установит все зависимые пакеты.

.. note::
   Самой распространенной проблемой при установке является уставка 
   пакета psycopg2, который необходим для работы с СУБД PostgreSQL. 
   Перед его установкой необходимо установить PostgreSQL 
   и пакеты postgresql-devel. Автор использует PostgreSQL 9.4    


Восстановление бекапа базы данных
#################################

Если не установлен PostgreSQL 
`установите <http://www.postgresql.org/docs/9.3/static/install-procedure.html>`_
и `настройте его <http://www.postgresql.org/docs/9.3/static/creating-cluster.html>`_.

Залогиньтесь как root::
   
   $ su -
   
Войдите под пользователем postgres и запустите psql::

   $ su postgres
   $ psql

Создайте нового пользователя и базу данных::

   postgres=# create user travelcrm with password 'mypassword' createdb superuser;
   postgres=# create database travelcrm with owner travelcrm;
   postgres=# \q;

База данных создана, осталось развернуть бекап. Выходим из пользователя 
postgres и root::

   $ exit
   $ exit

Разварачиваем бекап::

   $ psql -U travelcrm travelcrm < ./travelcrm-0.6.4.dev0/sql/travelcrm_en.sql


Настройка приложения
####################
Откройте в любом редакторе файл ./travelcrm-0.6.4.dev0/development.ini 
и найдите там строку начинающуюся на *sqlalchemy.url* 
и установите свои параметры подкючения к базе данных.


Запуск приложения
#################
Для запуска приложения выполните комманду::

   $ cd ~/Projects/virtenv
   $ ./bin/pserve --reload ./travelcrm-0.6.4.dev0/development.ini
   
Вы должны увидеть что-то вроде::

   Starting server in PID 8150.
   serving on http://0.0.0.0:6543

Это означает, что приложение успешно запущено и слушает порт *6543*

Откройте веб брайзер и перейдите по адресу `http:://localhost:6543 <http:://localhost:6543>`_
Для входа в систему используйте логин - **admin**, пароль - **adminadmin**
   